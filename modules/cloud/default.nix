{ config, ... }: {

    imports = [
        ./rclone.nix
    ];

    config = {
        cloud.rclone.enable = true;
        cloud.rclone.googleDrive.enable = true;
    };
}
