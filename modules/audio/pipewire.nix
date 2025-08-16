{ config, lib, pkgs, ... }:

{
  options.audio.pipewire.enable = lib.mkEnableOption "PipeWire audio system";

  config = lib.mkIf config.audio.pipewire.enable {
    security.rtkit.enable = true;
    
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
      pipewire
      pulseaudio
    ];
  };
}