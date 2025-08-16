{ config, lib, pkgs, ... }:

{
  options.audio.vm.enable = lib.mkEnableOption "VM-optimized audio configuration";

  config = lib.mkIf config.audio.vm.enable {
    # Enable base PipeWire configuration
    audio.pipewire.enable = true;

    # VM-specific PipeWire optimizations to fix audio stuttering
    services.pipewire = {
      # WirePlumber configuration for VM audio optimization
      wireplumber.extraConfig."51-alsa-vm" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "~alsa_card.*";
              }
            ];
            actions = {
              update-props = {
                # Increase headroom to 8192 for VM audio stability
                "api.alsa.headroom" = 16384;
                # Set VM-appropriate period size
                "api.alsa.period-size" = 4096;
                # Increase buffer size for VMs
                "api.alsa.period-num" = 64;
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
          # VM-optimized quantum settings
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 8192;
          # Increase allowed memory usage for buffers in VMs
          "mem.warn-mlock" = false;
          "mem.allow-mlock" = true;
        };
      };

      # PulseAudio compatibility configuration for VMs
      extraConfig.pipewire-pulse."99-vm-pulse" = {
        "pulse.properties" = {
          # VM-specific pulse properties
          "pulse.min.req" = "1024/48000";
          "pulse.default.req" = "2048/48000";
          "pulse.max.req" = "8192/48000";
          "pulse.min.quantum" = "1024/48000";
          "pulse.max.quantum" = "8192/48000";
        };
        "stream.properties" = {
          "node.latency" = "1024/48000";
          "resample.quality" = 1;
        };
      };
    };
  };
}
