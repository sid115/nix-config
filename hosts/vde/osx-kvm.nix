{ inputs, ... }:

# https://github.com/kholia/OSX-KVM

{
  imports = [ inputs.core.nixosModules.virtualisation ];

  users.extraUsers.sid.extraGroups = [ "libvirtd" ];

  # https://github.com/kholia/OSX-KVM/blob/master/kvm_amd.conf
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
}
