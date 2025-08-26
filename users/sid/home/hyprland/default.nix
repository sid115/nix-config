{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./anyrun.nix
    # ./bitwarden.nix
    ./flatpak.nix
    ./fzf-open.nix
    ./gemini-cli.nix
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

  dbus.packages = [
    pkgs.gnome-keyring
  ];
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring/control";
  };
}
