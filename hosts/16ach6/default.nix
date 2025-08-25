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
    ./virtualisation.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.docker
    outputs.nixosModules.docs
  ];

  networking.hostName = "16ach6";

  services = {
    openssh.enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  normalUsers = {
    sid = {
      extraGroups = [
        "audio"
        "dialout"
        "floppy"
        "input"
        "lp"
        "networkmanager"
        "video"
      ];
    };
  };

  system.stateVersion = "24.11";
}
