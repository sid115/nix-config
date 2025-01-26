{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./secrets

    inputs.core.homeModules.common
    inputs.core.homeModules.nixvim
    inputs.core.homeModules.sops

    outputs.homeModules.common
  ];

  home.username = "sid";

  programs.git = {
    enable = true;
    userName = "sid";
    userEmail = "sid@portuus.de";
  };

  programs.nixvim.enable = true;

  # xdg might not be available, hence `home.file`
  home.file.nixpkgs_config = {
    target = ".config/nixpkgs/config.nix";
    text = ''
      { allowUnfree = true; }
    '';
  };

  home.shellAliases = {
    search-store = "find /nix/store -maxdepth 1 -type d | rg -i";
  };

  # Nix access tokens
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    !include ${config.sops.templates.access-tokens.path}
  '';
  # If tokens got updated, remove old ones:
  # sudo rm -f /home/sid/.config/sops-nix/secrets/rendered/access-tokens

  home.stateVersion = "24.11";
}
