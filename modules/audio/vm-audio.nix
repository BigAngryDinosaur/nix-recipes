{ config, lib, pkgs, ... }:

{
  options.audio.vm.enable = lib.mkEnableOption "VM-optimized audio configuration";

  config = lib.mkIf config.audio.vm.enable {
    # Enable base PipeWire configuration
    audio.pipewire.enable = true;

    # VM-specific PipeWire optimizations to fix audio stuttering
    services.pipewire = {
      # WirePlumber configuration using proven VMware fix
      wireplumber.extraConfig."50-alsa-vm" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                # Proven working values for VMware audio
                "api.alsa.period-size" = 1024;
                "api.alsa.headroom" = 8192;
              };
            };
          }
        ];
      };

      # PipeWire configuration optimized for VMs
      extraConfig.pipewire."99-vm-low-latency" = {
        "context.properties" = {
          # Set appropriate clock rate for VMs
          "default.clock.rate" = 48000;
          # Smaller quantum values work better in VMs (from NixOS discourse)
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 1024;
          # Increase allowed memory usage for buffers in VMs
          "mem.warn-mlock" = false;
          "mem.allow-mlock" = true;
        };
      };

      # PulseAudio compatibility configuration for VMs
      extraConfig.pipewire-pulse."99-vm-pulse" = {
        "pulse.properties" = {
          # Smaller buffer sizes to match quantum settings
          "pulse.min.req" = "32/48000";
          "pulse.default.req" = "1024/48000";
          "pulse.max.req" = "8192/48000";
          "pulse.min.quantum" = "32/48000";
          "pulse.max.quantum" = "1024/48000";
        };
        "stream.properties" = {
          "node.latency" = "1024/48000";
          "resample.quality" = 1;
        };
      };
    };
  };
}
