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
  };

  hardware.graphics.enable = true;

  environment.systemPackages = [
    pkgs.looking-glass-client
    pkgs.quickemu
  ];

  # https://github.com/quickemu-project/quickemu
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
  users.extraGroups.libvirtd.members = [ "sid" ];
  users.extraGroups.qemu-libvirtd.members = [ "sid" ];
  users.extraGroups.kvm.members = [ "sid" ];

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 sid libvirtd -" ];

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x1f9d", ATTR{driver_override}="vfio-pci"
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x1f9d", RUN+="${pkgs.kmod}/bin/modprobe vfio-pci"
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{device}=="0x1f9d", RUN+="${pkgs.busybox}/bin/sh -c 'echo 0000:\$PCI_SLOT_NAME > /sys/bus/pci/drivers/vfio-pci/bind'"
  # '';

  # systemd.services.forceRebindNVUSB = {
  #   enable = true;
  #   description = "forceRebindNvUsb";
  #   wantedBy = [ "multi-user.target" ];
  #   script = ''
  #     echo -n "${pciBusAddress}" > /sys/bus/pci/drivers/xhci_hcd/unbind
  #     echo -n "${pciBusAddress}" > /sys/bus/pci/drivers/vfio-pci/bind
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  # };
}
