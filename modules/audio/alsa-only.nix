{ config, lib, pkgs, ... }:

{
  options.audio.alsa-only.enable = lib.mkEnableOption "ALSA-only audio configuration (bypass PipeWire)";

  config = lib.mkIf config.audio.alsa-only.enable {
    # Disable PipeWire and PulseAudio completely
    services.pipewire.enable = lib.mkForce false;
    services.pulseaudio.enable = lib.mkForce false;
    
    # Enable ALSA (modern way)
    hardware.alsa.enable = true;
    
    # ALSA configuration optimized for VMs
    environment.etc."asound.conf".text = ''
      pcm.!default {
        type hw
        card 0
        device 0
        period_size 1024
        buffer_size 8192
      }
      
      ctl.!default {
        type hw
        card 0
      }
      
      # VM-specific timing settings
      pcm.vmware {
        type hw
        card 0
        device 0
        period_size 1024
        buffer_size 8192
        periods 4
      }
    '';

    # Install ALSA utilities
    environment.systemPackages = with pkgs; [
      alsa-utils
      alsa-oss
    ];
    
    # Ensure proper permissions for audio group
    users.groups.audio = {};
  };
}
