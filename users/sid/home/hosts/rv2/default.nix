{
  imports = [ ../../hyprland ];

  wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, 1920x1200, 0x0, 1"
    "DVI-I-1, 1280x1024, 1920x0, 1, transform, 1"
  ];

  programs.waybar.settings.mainBar.output = "HDMI-A-1";
}
