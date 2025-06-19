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
    # ./vfio.nix # FIXME

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.nvidia
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualization

    outputs.nixosModules.common
  ];

  networking.hostName = "16ach6";

  services = {
    openssh.enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  # virtualisation.docker.enable = true;
  # users.extraGroups.docker.members = [ "sid" ];
  # environment.systemPackages = [ pkgs.docker-compose ];

  # https://github.com/quickemu-project/quickemu
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
  environment.systemPackages = [ pkgs.quickemu ];
  users.extraGroups.libvirtd.members = [ "sid" ];
  users.extraGroups.qemu-libvirtd.members = [ "sid" ];

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
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };

  system.stateVersion = "24.11";
}
