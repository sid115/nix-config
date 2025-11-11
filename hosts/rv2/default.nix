{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./secrets

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualisation
    inputs.core.nixosModules.windows-oci

    outputs.nixosModules.common
    # outputs.nixosModules.docker # conflicts with `virtualisation.podman.dockerCompat`
    outputs.nixosModules.docs
    outputs.nixosModules.tailscale
    outputs.nixosModules.wine
  ];

  networking.hostName = "rv2";

  programs.adb.enable = true;
  users.users.sid.extraGroups = [
    "adbusers"
    "kvm"
  ];

  services = {
    openssh.enable = true;
    windows-oci = {
      # enable = true;
      sharedVolume = "/home/sid/pub";
    };
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
        "libvirtd"
        "lp"
        "networkmanager"
        "video"
      ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "25.05";
}
