{ inputs, pkgs, ... }:

{
  imports = [ inputs.core.nixosModules.virtualisation ];

  # boot.kernelParams = [
  #   "amd_iommu=on"
  #   "pcie_aspm=off"
  # ];
  # boot.kernelModules = [ "kvm-amd" ];
  # boot.blacklistedKernelModules = [
  #   "nvidia"
  #   "nouveau"
  # ];
  # boot.initrd.availableKernelModules = [
  #   "amdgpu"
  #   "vfio-pci"
  # ];
  # boot.initrd.preDeviceCommands = ''
  #   DEVS="0000:00:01.0"
  #   for DEV in $DEVS; do
  #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
  #   done
  #   modprobe -i vfio-pci
  # '';

  # systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 sid libvirtd -" ];

  environment.systemPackages = [ pkgs.looking-glass-client ];

  normalUsers.sid.extraGroups = [ "libvirtd" ];
}
