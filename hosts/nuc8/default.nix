{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop # for Bluetooth
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.pipewire

    outputs.nixosModules.common
  ];

  networking.hostName = "nuc8";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
  };

  normalUsers = {
    sid = {
      name = "sid";
      extraGroups = [
        "input"
        "audio"
        "floppy"
        "lp"
        "video"
        "wheel"
        "networkmanager"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "24.11";
}
