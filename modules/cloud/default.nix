{ config, ... }: {

    imports = [
        ./rclone.nix
    ];

    config = {
        cloud.rclone.enable = true;
        cloud.rclone.googleDrive.enable = true;
        cloud.rclone.googleDrive.autoMount = true;
        cloud.rclone.googleDrive.enableSync = false;  # Prevent conflicts with mounting
    };
}
