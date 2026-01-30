{ config, lib, pkgs, ... }:

{
  options.audio.minimal-alsa.enable = lib.mkEnableOption "Minimal ALSA configuration for problematic VMs";

  config = lib.mkIf config.audio.minimal-alsa.enable {
    # Disable ALL audio systems
    services.pipewire.enable = lib.mkForce false;
    services.pulseaudio.enable = lib.mkForce false;
    
    # Bare minimum ALSA
    hardware.alsa.enable = true;
    
    # Minimal packages
    environment.systemPackages = with pkgs; [
      alsa-utils  # Just basic ALSA tools
    ];

    # Basic ALSA config - no complex routing
    environment.etc."asound.conf".text = ''
      pcm.!default {
        type hw
        card 0
        device 0
      }
      
      ctl.!default {
        type hw
        card 0
      }
    '';

    # Ensure audio group exists but don't auto-add users
    users.groups.audio = {};
  };
}