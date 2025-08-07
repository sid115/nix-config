{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./git.nix
    ./home.nix
    ./nix.nix
    ./nixvim.nix
    ./secrets

    inputs.core.homeModules.common

    outputs.homeModules.common
  ];
}
