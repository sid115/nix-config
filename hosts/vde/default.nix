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

    inputs.core.nixosModules.common
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
  ];

  networking.hostName = "vde";
  networking.domain = "vde.fritz.box";

  services = {
    openssh.enable = true;
  };

  normalUsers = {
    sid = {
      name = "sid";
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ../../users/sid/pubkeys/gpg.pub
      ];
    };
  };

  system.stateVersion = "24.11";
}
