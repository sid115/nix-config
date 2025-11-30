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
    ./services.nix

    ../../users/sid

    inputs.core.nixosModules.common

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  system.stateVersion = "24.11";
}
