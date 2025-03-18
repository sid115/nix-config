{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-16ach6
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Trying to fix: DRM kernel driver 'nvidia-drm' in use. NVK requires nouveau.
  # hardware.nvidia.modesetting.enable = true;
  # hardware.graphics.enable = true; # for nouveau drivers
  # boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  # environment.variables = {
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   NVD_BACKEND = "direct";
  #   VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # };
  # environment.systemPackages = [
  #   pkgs.libva
  #   pkgs.libva-utils
  #   pkgs.libvdpau
  #   pkgs.libvdpau-va-gl
  #   pkgs.vaapiVdpau
  # ];
}
