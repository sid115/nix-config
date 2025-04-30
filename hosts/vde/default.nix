{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./hardware.nix
    ./osx-kvm.nix
    ./packages.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.pipewire

    outputs.nixosModules.common
  ];

  networking.hostName = "vde";
  networking.domain = "vde.fritz.box";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
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

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "24.11";
}
