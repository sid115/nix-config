{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./open-webui-oci.nix
    ./packages.nix
    ./print-server.nix
    ./secrets

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.miniflux
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    # outputs.nixosModules.monero
    outputs.nixosModules.tailscale
  ];

  networking.hostName = "rx4";
  networking.domain = "rx4.lan";

  services = {
    miniflux = {
      enable = true;
      config = {
        ADMIN_USERNAME = "sid";
      };
    };
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
    transmission.enable = true;
  };

  system.stateVersion = "25.11";
}
