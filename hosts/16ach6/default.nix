{
  inputs,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./vfio.nix # FIXME

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.pipewire

    outputs.nixosModules.common
  ];

  networking.hostName = "16ach6";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
  };

  # virtualisation.docker.enable = true;
  # users.extraGroups.docker.members = [ "sid" ];
  # environment.systemPackages = [ pkgs.docker-compose ];

  normalUsers = {
    sid = {
      name = "sid";
      extraGroups = [
        "audio"
        "dialout"
        "floppy"
        "input"
        "lp"
        "networkmanager"
        "video"
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };

  system.stateVersion = "24.11";
}
