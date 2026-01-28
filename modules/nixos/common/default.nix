{
  imports = [
    ./nix.nix
    ./overlays.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
