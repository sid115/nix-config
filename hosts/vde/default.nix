{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./hardware.nix
    ./packages.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.pipewire
    inputs.core.nixosModules.virtualization

    outputs.nixosModules.common
  ];

  networking.hostName = "vde";
  networking.domain = "vde.fritz.box";

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
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ../../users/sid/pubkeys/gpg.pub
      ];
    };
  };

  system.stateVersion = "24.11";
}
