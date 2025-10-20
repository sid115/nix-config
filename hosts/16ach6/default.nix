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
    # ./winapps.nix # trying windows-oci for now
    # ./wireguard.nix # TODO: use NM for client config

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.i2pd
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.windows-oci

    outputs.nixosModules.common
    # outputs.nixosModules.docker # conflicts with `virtualisation.podman.dockerCompat`
    outputs.nixosModules.docs
    outputs.nixosModules.wine
  ];

  networking.hostName = "16ach6";

  services = {
    i2pd.enable = true;
    openssh.enable = true;
    windows-oci = {
      enable = true;
      sharedVolume = "/home/sid/pub";
    };
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
