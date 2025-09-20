{ inputs, pkgs, ... }:

{
  environment.systemPackages = with inputs.winapps.packages."${pkgs.system}"; [
    winapps
    winapps-launcher
  ];
}
