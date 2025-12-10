{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./secrets

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.tailscale
  ];

  networking.hostName = "vde";
  networking.domain = "vde.lan";

  system.stateVersion = "25.11";
}
