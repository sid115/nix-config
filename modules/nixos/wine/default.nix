{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.waylandFull
    winetricks
  ];

  hardware.graphics.enable32Bit = true;
}
