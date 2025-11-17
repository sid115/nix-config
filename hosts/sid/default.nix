{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./maubot.nix
    ./packages.nix
    ./services.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  system.stateVersion = "24.11";
}
