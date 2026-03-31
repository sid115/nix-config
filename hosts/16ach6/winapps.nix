{ inputs, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = with inputs.winapps.packages."${system}"; [
    winapps
    winapps-launcher
  ];
}
