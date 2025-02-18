{
  imports = [ ../../hyprland ];

  # wayland.windowManager.hyprland.extraConfig = ''
  #   monitor = eDP-1, 2560x1600@120, 0x0, 1.25
  #   monitor = desc:LG Electronics 34GL750 0x000417A0, 2560x1080@60, auto, 1
  #   monitor = desc:Eizo Nanao Corporation S2433W 24885089, 1920x1200, auto, 1, transform, 1
  # '';

  # programs.waybar.settings.mainBar.output = "eDP-1";

  services.spotifyd.settings.device_name = "nuc";
}
