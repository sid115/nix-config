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
    ./secrets
    ./virtualisation.nix
    ./winapps.nix
    # ./wireguard.nix

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

  virtualisation.waydroid.enable = true;
  # sudo waydroid init
  # sudo systemctl enable --now waydroid-container.service
  # waydroid session start
  # waydroid app launch com.foo.bar

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
