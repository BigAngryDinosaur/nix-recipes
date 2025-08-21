{ config, lib, pkgs, userSettings, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;
  
  cfg = config.cloud.rclone;
  gdCfg = cfg.googleDrive;
in
{
  options = {
    cloud.rclone = {
      enable = mkEnableOption "Enable rclone cloud sync";
      
      package = mkOption {
        type = types.package;
        default = pkgs.rclone;
        description = "The rclone package to use";
      };
      
      googleDrive = {
        enable = mkEnableOption "Enable Google Drive integration";
        
        remoteName = mkOption {
          type = types.str;
          default = "gdrive";
          description = "Name of the Google Drive remote in rclone config";
        };
        
        mountPath = mkOption {
          type = types.str;
          default = "/home/${userSettings.username}/GoogleDrive";
          description = "Local mount path for Google Drive";
        };
        
        autoMount = mkOption {
          type = types.bool;
          default = true;
          description = "Automatically mount Google Drive on boot";
        };
        
        syncPath = mkOption {
          type = types.str;
          default = "/home/${userSettings.username}/GoogleDriveSync";
          description = "Local sync directory for Google Drive";
        };
        
        enableSync = mkOption {
          type = types.bool;
          default = false;
          description = "Enable bidirectional sync service (alternative to mounting)";
        };
        
        vfsCacheMode = mkOption {
          type = types.enum [ "off" "minimal" "writes" "full" ];
          default = "writes";
          description = "VFS cache mode for better performance";
        };
        
        syncInterval = mkOption {
          type = types.str;
          default = "5m";
          description = "Interval for sync service (systemd timer format)";
        };
        
        remotePath = mkOption {
          type = types.str;
          default = "";
          description = "Remote path within Google Drive (empty for root)";
        };
        
        allowOther = mkOption {
          type = types.bool;
          default = false;
          description = "Allow access to the mount by other users (requires root privileges)";
        };
      };
    };
  };
  
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    
    
    
    # Google Drive sync service (alternative to mounting)
    systemd.services.rclone-gdrive-sync = mkIf (gdCfg.enable && gdCfg.enableSync) {
      description = "Sync Google Drive via rclone bisync";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p ${gdCfg.syncPath}"
          "${pkgs.coreutils}/bin/chown ${userSettings.username}:users ${gdCfg.syncPath}"
        ];
        ExecStart = "${cfg.package}/bin/rclone bisync ${gdCfg.remoteName}:${gdCfg.remotePath} ${gdCfg.syncPath} --verbose --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient";
        User = userSettings.username;
        Group = "users";
      };
      
      preStart = ''
        # Check if rclone config exists and has the remote configured
        if ! ${cfg.package}/bin/rclone listremotes | grep -q "^${gdCfg.remoteName}:$"; then
          echo "ERROR: Google Drive remote '${gdCfg.remoteName}' not configured in rclone."
          echo "Please run: rclone config"
          echo "And configure a Google Drive remote named '${gdCfg.remoteName}'"
          exit 1
        fi
        
        # Initialize bisync if needed
        if [ ! -f "${gdCfg.syncPath}/.rclone-bisync-state" ]; then
          echo "Initializing rclone bisync..."
          ${cfg.package}/bin/rclone bisync ${gdCfg.remoteName}:${gdCfg.remotePath} ${gdCfg.syncPath} --resync --verbose --create-empty-src-dirs
        fi
      '';
    };
    
    # Timer for sync service
    systemd.timers.rclone-gdrive-sync = mkIf (gdCfg.enable && gdCfg.enableSync) {
      description = "Timer for Google Drive sync";
      wantedBy = [ "timers.target" ];
      
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = gdCfg.syncInterval;
        Persistent = true;
      };
    };
    
    # Enable FUSE for mounting
    programs.fuse.userAllowOther = mkIf (gdCfg.enable && gdCfg.autoMount) true;
    
    # Add user to fuse group if needed
    users.users.${userSettings.username} = mkIf (gdCfg.enable && gdCfg.autoMount) {
      extraGroups = [ "fuse" ];
    };
    
    # Home manager configuration for rclone
    home-manager.users.${userSettings.username} = mkIf cfg.enable {
      home.packages = [ cfg.package ];
      
      # User-level systemd service for mounting Google Drive
      systemd.user.services.rclone-gdrive-mount = mkIf (gdCfg.enable && gdCfg.autoMount) {
        Unit = {
          Description = "Mount Google Drive via rclone";
          After = [ "graphical-session.target" ];
        };
        
        Service = {
          Type = "notify";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${gdCfg.mountPath}";
          ExecStart = "${cfg.package}/bin/rclone mount ${gdCfg.remoteName}:${gdCfg.remotePath} ${gdCfg.mountPath} --vfs-cache-mode=${gdCfg.vfsCacheMode}${lib.optionalString gdCfg.allowOther " --allow-other"}";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u ${gdCfg.mountPath}";
          Restart = "on-failure";
          RestartSec = "10s";
        };
        
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}