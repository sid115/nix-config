{ inputs, outputs, ... }:

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
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.pipewire

    outputs.nixosModules.common
  ];

  networking.hostName = "16ach6";

  services = {
    openssh.enable = true;
    pipewire.enable = true;
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "sid" ];

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

  system.stateVersion = "24.11";
}
