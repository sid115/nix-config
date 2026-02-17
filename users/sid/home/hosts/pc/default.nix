{ lib, ... }:

{
  imports = [ ../../hyprland ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-3, 2560x1080@144, 1920x0, 1"
    "HDMI-A-1, 1920x1080@144, 0x0, 1"
  ];

  programs.waybar.settings.mainBar.output = "DP-3";

  home.stateVersion = lib.mkForce "25.11";
}
