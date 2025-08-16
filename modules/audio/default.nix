{ config, lib, pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./vm-audio.nix
  ];
}