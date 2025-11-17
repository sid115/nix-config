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
    ./router.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    # outputs.nixosModules.monero
  ];

  networking.hostName = "rx4";
  networking.domain = "rx4.lan";

  services = {
    openssh.enable = true;
    # monero = {
    #   enable = true;
    #   mining.address = "";
    # };
    # xmrig.settings = {
    #   cpu = {
    #     max-threads-hint = 4;
    #   };
    # };
  };

  system.stateVersion = "25.11";
}
