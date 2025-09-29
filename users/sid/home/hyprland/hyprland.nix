{ inputs, pkgs, ... }:

{
  imports = [ inputs.core.homeModules.hyprland ];

  wayland.windowManager.hyprland = {
    enable = true;
    autostart = true;
    settings = {
      bind =
        let
          flatpakRun = "${pkgs.flatpak}/bin/flatpak --user run";
        in
        [
          "$mod,       g, exec, gimp"
          "$mod,       s, exec, kitty -T spotify -e spotify_player"
          "$mod,       v, exec, virt-manager"
          "$mod,       z, exec, ${flatpakRun} us.zoom.Zoom"
          "$mod CTRL,  m, exec, ${flatpakRun} org.mypaint.MyPaint"
          "$mod CTRL,  o, exec, obs"
          "$mod CTRL,  p, exec, otp"
          "$mod SHIFT, a, exec, chromium --app=https://ai.sid.ovh"
        ];
      windowrule = [
        "workspace 4, title:^newsboat$"
        "workspace 6, class:^thunderbird$, title:Thunderbird$"
        "workspace 7, title:^Jellyfin Media Player$"
        "workspace 7, title:^spotify$"
        "workspace 8, class:^Element$, title:^Element"
        "workspace 9, class:^chrome-ai.portuus.de"
        "workspace 10, class:^zoom$, title:^Zoom"
        "workspace 10, class:^org.qbittorrent.qBittorrent$"
        "workspace 10, title:^Virtual Machine Manager$"
      ];
      exec-once = [
        "[workspace 5 silent] librewolf"
        "[workspace 6 silent] thunderbird"
      ];
    };
  };
}
