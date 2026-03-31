{
  imports = [
    ./overlays.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # trace: warning: `programs.ssh` default values will be removed in the future.
  # Consider setting `programs.ssh.enableDefaultConfig` to false,
  # and manually set the default values you want to keep at
  # `programs.ssh.matchBlocks."*"`.
  programs.ssh.enableDefaultConfig = false;
}
