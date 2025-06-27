{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop # for Bluetooth
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualization

    outputs.nixosModules.common
    outputs.nixosModules.docs
  ];

  networking.hostName = "nuc8";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
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
      ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "24.11";
}
