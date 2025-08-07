{ config, pkgs, ... }:

{
  # Nix access tokens
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    !include ${config.sops.templates.access-tokens.path}
  '';
  # If tokens got updated, remove old ones:
  # sudo rm -f /home/sid/.config/sops-nix/secrets/rendered/access-tokens

  sops.templates.access-tokens.content = ''
    access-tokens = github.com=${config.sops.placeholder.github-token}
  '';
}
