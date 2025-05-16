{ pkgs, ... }:

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
      hostname = "192.168.122.15";
      port = 22;
      user = "sid";
    };
    ubuntu = {
      host = "u ubuntu";
      hostname = "127.0.0.1";
      port = 3022;
      user = "thk";
    };
    vde = {
      host = "v vde";
      hostname = "192.168.188.22";
      port = 2299;
      user = "sid";
    };
    vde-win10 = {
      host = "vw vde-win10";
      hostname = "192.168.188.22";
      port = 22;
      user = "sid";
    };
  };

  programs.sftpman.mounts = {
    arch = {
      host = "192.168.122.15";
      user = "sid";
      port = 22;
      mountPoint = "/home/sid";
    };
    ubuntu = {
      host = "127.0.0.1";
      user = "thk";
      port = 3022;
      mountPoint = "/home/thk/Desktop/iceduino_setup";
    };
    vde = {
      host = "192.168.188.22";
      user = "sid";
      port = 2299;
      mountPoint = "/home/sid/.config/nixos";
    };
  };

  home.shellAliases = {
    vbox-up = "VBoxManage startvm ubuntu-sopc --type headless";
    vbox-down = "VBoxManage controlvm ubuntu-sopc poweroff";
    vbox-list = "VBoxManage list vms --long | grep -e '^Name:' -e '^State:'";

    dock-on = "hyprctl keyword monitor eDP-1, disable";
    dock-off = "hyprctl keyword monitor eDP-1, enable";
  };

  services.spotifyd.settings.device_name = "16ach6";
}
