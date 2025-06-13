{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualization

    outputs.nixosModules.common
  ];

  networking.hostName = "rv2";

  services = {
    openssh.enable = true;
  };

  normalUsers = {
    sid = {
      extraGroups = [
        "audio"
        "floppy"
        "input"
        "libvirtd"
        "lp"
        "networkmanager"
        "video"
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "25.05";
}
