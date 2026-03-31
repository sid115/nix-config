{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./packages.nix
    ./secrets
    ./services.nix

    ../../users/sid

    inputs.core.nixosModules.bluetooth
    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.desktop
    inputs.core.nixosModules.hyprland

    outputs.nixosModules.common
    outputs.nixosModules.docs
    # outputs.nixosModules.syncthing
    outputs.nixosModules.tailscale
    outputs.nixosModules.wine
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

  programs.steam.enable = true;

  boot.enableContainers = true;

  system.stateVersion = "25.11";
}
