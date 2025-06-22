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

    ../../users/sid

    inputs.core.nixosModules.audio
    inputs.core.nixosModules.common
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
  ];

  networking.hostName = "vde";
  networking.domain = "vde.fritz.box";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "24.11";
}
