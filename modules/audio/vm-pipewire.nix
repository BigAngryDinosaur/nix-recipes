{ config, lib, pkgs, ... }:

{
  options.audio.vm-pipewire.enable = lib.mkEnableOption "VMware-optimized PipeWire with timer fixes";

  config = lib.mkIf config.audio.vm-pipewire.enable {
    # Enable base PipeWire configuration
    audio.pipewire.enable = true;

    # VMware HD-Audio Generic kernel module configuration  
    boot.extraModprobeConfig = ''
      # Disable timer-based scheduling for VMware audio passthrough
      options snd-hda-intel enable_msi=0 single_cmd=1 probe_mask=1
      # ALSA timer-based scheduling fixes for VMs
      options snd slots=snd-hda-intel
    '';

    # VM performance kernel parameters to prevent system-wide stuttering
    boot.kernelParams = [
      # VMware guest optimizations
      "clocksource=tsc"
      "tsc=reliable" 
      "no_timer_check"
      "nohz=off"
      # Prevent CPU frequency scaling issues in VMs
      "intel_pstate=disable"
      # Audio priority fixes
      "threadirqs"
    ];

    # PipeWire configuration optimized for VMware timing issues
    services.pipewire = {
      # Disable timer-based scheduling that causes VMware issues
      extraConfig.pipewire."99-vmware-timer-fix" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          # Larger buffers to prevent system overload
          "default.clock.quantum" = 4096;
          "default.clock.min-quantum" = 2048;
          "default.clock.max-quantum" = 8192;
          # Disable problematic timer features
          "clock.power-of-two-quantum" = false;
          "mem.warn-mlock" = false;
          "mem.allow-mlock" = false;
          # VMware-specific timing tolerance
          "default.clock.force-rate" = 48000;
          # Reduce audio priority to prevent system interference
          "core.daemon" = true;
          "core.name" = "pipewire-0";
        };
        "context.modules" = [
          { 
            name = "libpipewire-module-rt";
            args = {
              "nice.level" = 10;
              "rt.prio" = 20;
              "rt.time.soft" = 2000000;
              "rt.time.hard" = 2000000;
            };
          }
        ];
      };

      # WirePlumber configuration for VMware HD-Audio Generic
      wireplumber.extraConfig."50-vmware-hda" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.name" = "~alsa_card.*Generic*"; }
              { "node.name" = "~alsa_output.*Generic*"; }
            ];
            actions = {
              update-props = {
                # VMware HD-Audio passthrough specific values
                "api.alsa.period-size" = 2048;
                "api.alsa.headroom" = 32768;
                "api.alsa.disable-mmap" = true;
                "api.alsa.disable-tsched" = true;
                "device.profile.switch" = false;
              };
            };
          }
        ];
      };

      # PulseAudio compatibility for VMware
      extraConfig.pipewire-pulse."99-vmware-pulse" = {
        "pulse.properties" = {
          "pulse.min.req" = "2048/48000";
          "pulse.default.req" = "4096/48000";
          "pulse.max.req" = "16384/48000";
          "pulse.min.quantum" = "2048/48000";
          "pulse.max.quantum" = "4096/48000";
        };
        "stream.properties" = {
          "node.latency" = "4096/48000";
          "resample.quality" = 1;
          "channelmix.normalize" = false;
        };
      };
    };

    # Install audio utilities
    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
      pipewire
    ];
  };
}