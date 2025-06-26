{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # ./anyrun.nix
    # ./bitwarden.nix
    ./flatpak.nix
    ./fzf-open.nix
    ./gpg.nix
    ./packages.nix
    ./programs.nix
    # ./recoll.nix
    ./rclone.nix
    ./services.nix
    ./ssh-hosts.nix
    ./xdg.nix

    inputs.core.homeModules.hyprland
    inputs.core.homeModules.styling
    inputs.core.homeModules.virtualization
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    autostart = true;
    settings = {
      bind =
        let
          flatpak = "${pkgs.flatpak}/bin/flatpak";
        in
        [
          "$mod,       g, exec, gimp"
          "$mod,       s, exec, kitty -T spotify -e spotify_player"
          "$mod,       v, exec, virt-manager"
          "$mod,       z, exec, ${flatpak} run us.zoom.Zoom"
          "$mod CTRL,  o, exec, obs"
          "$mod CTRL,  p, exec, otp"
          "$mod SHIFT, a, exec, chromium --app=https://ai.portuus.de"
        ];
      windowrulev2 = [
        "workspace 4, title:^newsboat$"
        "workspace 6, class:^thunderbird$, title:Thunderbird$"
        "workspace 7, title:^Jellyfin Media Player$"
        "workspace 7, title:^spotify$"
        "workspace 8, class:^Element$, title:^Element"
        "workspace 9, class:^chrome-ai.portuus.de"
        "workspace 10, class:^zoom$, title:^Zoom"
        "workspace 10, class:^org.qbittorrent.qBittorrent$"
        "workspace 10, title:^Virtual Machine Manager$"

        "float, class:^Open Files$"
      ];
      exec-once = [
        "[workspace 5 silent] librewolf"
        "[workspace 6 silent] thunderbird"
        "[workspace 8 silent] element-desktop"
      ];
    };
  };

  styling = {
    enable = true;
    scheme = "oxocarbon";
  };

  home.shellAliases = {
    bt = "bluetoothctl";
    dd-iso = "dd bs=4M status=progress oflag=sync";
    nc-sync = "nextcloud-sync-all";
    synapse_change_display_name = "${pkgs.core.synapse_change_display_name}/bin/synapse_change_display_name -t $(${pkgs.pass}/bin/pass sid.ovh/matrix/access-token) -r sid.ovh";
  };
}
