{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.core.nixosModules.virtualisation ];

  virtualisation = {
    vfio = {
      enable = true;
      IOMMUType = "amd";
      devices = [
        "10de:1f9d"
      ];
      blacklistNvidia = true;
      ignoreMSRs = true;
    };
    libvirtd.deviceACL = [
      "/dev/kvm"
      "/dev/net/tun"
      "/dev/vfio/vfio"
      "/dev/null"
      "/dev/ptmx"
    ];
    hugepages.enable = true;
    quickemu.enable = true;
  };

  users.extraGroups.libvirtd.members = [ "sid" ];
  users.extraGroups.qemu-libvirtd.members = [ "sid" ];
  users.extraGroups.kvm.members = [ "sid" ];

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 sid libvirtd -" ];

  environment.systemPackages = [
    pkgs.looking-glass-client
  ];
}
