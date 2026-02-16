{ config, lib, ... }:

let
  # NOTE: Add a "main user" option to normalUsers? This would also set a sane default for the Syncthing module.
  user = "sid";

  inherit (lib) mkDefault mkForce;
in
{
  programs.nh = {
    enable = mkDefault true;
    clean.enable = mkDefault true;
    clean.extraArgs = mkDefault "--keep-since 4d --keep 3";
    flake = config.users.users."${user}".home + "/.config/nixos";
  };

  nix.gc.automatic = mkForce false; # collides with `programs.nh.clean`
}
