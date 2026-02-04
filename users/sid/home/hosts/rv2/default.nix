{
  imports = [ ../../hyprland ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DVI-D-1, 1920x1200, 0x0, 1"
    "DVI-I-1, 1280x1024, 1920x0, 1, transform, 1"
  ];

  programs.waybar.settings.mainBar.output = "DVI-D-1";

  programs.ssh.matchBlocks = {
    arch = {
      host = "a arch";
      hostname = "192.168.122.12";
      port = 22;
      user = "sid";
    };
  };

  programs.sftpman.mounts = {
    arch = {
      host = "192.168.122.12";
      user = "sid";
      port = 22;
      mountPoint = "/home/sid";
    };
  };
}
