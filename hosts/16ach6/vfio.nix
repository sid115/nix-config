{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  deviceIDs = [
    "10de:1f9d"
  ];
  pciBusAddress = "0000:01:00.0"; # lspci -nnv -D | grep -i gtx

  inherit (lib) concatStringsSep;
in
{
  imports = [ inputs.core.nixosModules.virtualization ];

  boot = {
    kernelParams = [
      "amd_iommu=on"
      ("vfio-pci.ids=" + concatStringsSep "," deviceIDs)
    ];
    # postBootCommands = ''
    #   DEVS="0000:0f:00.0 0000:0f:00.1"
    #
    #   for DEV in $DEVS; do
    #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    #   done
    #   modprobe -i vfio-pci
    # '';
    kernelModules = [
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];
    blacklistedKernelModules = [
      "nvidia"
      "nouveau"
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 sid libvirtd -" ];

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

  environment.systemPackages = [ pkgs.looking-glass-client ];

  normalUsers.sid.extraGroups = [ "libvirtd" "qemu-libvirtd" ];
}
