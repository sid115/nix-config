{ inputs, pkgs, ... }:

{
  imports = [
    ./fzf-open.nix
    ./gpg.nix
    ./music.nix
    ./packages.nix
    ./programs.nix
    ./rclone.nix
    ./services.nix
    ./ssh-hosts.nix
    ./xdg.nix

    inputs.core.homeModules.hyprland
    inputs.core.homeModules.styling
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    autostart = true;
    settings = {
      bind = [
        "$mod,       g, exec, gimp"
        "$mod,       v, exec, virt-manager"
        "$mod,       z, exec, zoom-us"
        "$mod CTRL,  o, exec, obs"
        "$mod SHIFT, a, exec, chromium --app=https://ai.portuus.de"
      ];
      windowrulev2 = [
        "workspace 4, title:^newsboat$"
        "workspace 6, class:^thunderbird$, title:Thunderbird$"
        "workspace 7, title:^Jellyfin Media Player$"
        "workspace 7, title:^ncmpcpp$"
        "workspace 8, class:^Element$, title:^Element"
        "workspace 9, class:^chrome-ai.portuus.de"
        "workspace 10, class:^zoom$, title:^Zoom"
        "workspace 10, class:^org.qbittorrent.qBittorrent$"
        "workspace 10, title:^Virtual Machine Manager$"

        "float, class:^Open Files$"
      ];
    };
  };

  styling = {
    enable = true;
    scheme = "oxocarbon";
  };

  home.shellAliases = {
    bt = "bluetoothctl";
    synapse_change_display_name = "${pkgs.core.synapse_change_display_name}/bin/synapse_change_display_name -t $(${pkgs.pass}/bin/pass sid.ovh/matrix/access-token) -r sid.ovh";
  };
}
