{
  imports = [ ../../hyprland ];

  wayland.windowManager.hyprland.settings.monitor = [
    "desc:Eizo Nanao Corporation S2433W 24885089, 1920x1200, 0x0, 1"
    "desc:Eizo Nanao Corporation S1921 C9188037, 1280x1024, 1920x0, 1, transform, 1"
  ];

  home.sessionVariables = {
    AQ_NO_MODIFIERS = 1;
  };

  programs.waybar.settings.mainBar.output = "DP-2";

  services.spotifyd.settings.device_name = "nuc8";
}
