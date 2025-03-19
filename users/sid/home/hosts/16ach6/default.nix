{
  imports = [ ../../hyprland ];

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, 2560x1600@120, 0x0, 1.25"
    "desc:LG Electronics 34GL750 0x000417A0, 2560x1080@60, auto, 1"
    "desc:Eizo Nanao Corporation S2433W 24885089, 1920x1200, auto, 1" # , transform, 1"
  ];

  programs.waybar.settings.mainBar.output = "eDP-1";

  programs.ssh.matchBlocks = {
    arch = {
      host = "a arch";
      hostname = "192.168.122.120";
      port = 22;
      user = "sid";
    };
    debian = {
      host = "d debian";
      hostname = "192.168.122.208";
      port = 22;
      user = "sid";
    };
  };

  services.spotifyd.settings.device_name = "16ach6";
}
