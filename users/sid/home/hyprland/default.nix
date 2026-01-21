{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # ./anyrun.nix
    ./flatpak.nix
    ./fzf-open.nix
    ./gpg.nix
    ./hyprland.nix
    ./librewolf.nix
    ./newsboat.nix
    ./nextcloud-sync.nix
    ./obs-studio.nix
    ./opencode.nix
    ./packages.nix
    ./rclone.nix
    # ./recoll.nix
    ./shell-aliases.nix
    ./spotify-player.nix
    ./ssh-hosts.nix
    ./stylix.nix
    ./vscode.nix
    ./waybar.nix
    ./xdg.nix
    ./yazi.nix

    inputs.core.homeModules.virtualisation
  ];
}
