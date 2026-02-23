{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./secrets
    ./services.nix

    ../../users/sid

    inputs.core.nixosModules.bluetooth
    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.desktop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.virtualisation

    outputs.nixosModules.appimage
    outputs.nixosModules.common
    # outputs.nixosModules.docker # conflicts with `virtualisation.podman.dockerCompat`
    outputs.nixosModules.docs
    outputs.nixosModules.syncthing
    outputs.nixosModules.tailscale
    outputs.nixosModules.wine
  ];

  networking.hostName = "rv2";

  programs.steam.enable = true;

  programs.adb.enable = true;
  users.users.sid.extraGroups = [
    "adbusers"
    "kvm"
  ];

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
        "libvirtd"
        "lp"
        "networkmanager"
        "video"
      ];
    };
  };

  system.stateVersion = "25.05";
}
