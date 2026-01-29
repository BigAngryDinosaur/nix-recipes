{ config, lib, pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./vm-audio.nix
    ./alsa-only.nix
    ./vm-pipewire.nix
    ./minimal-alsa.nix
  ];
}