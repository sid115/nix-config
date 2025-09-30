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
    # ./router.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
  ];

  networking.hostName = "rx4";
  networking.domain = "rx4.local";

  services = {
    openssh.enable = true;
  };

  system.stateVersion = "25.11";
}
