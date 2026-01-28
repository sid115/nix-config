{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./secrets

    ../../users/sid

    inputs.core.nixosModules.bluetooth
    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.desktop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualisation
    inputs.core.nixosModules.windows-oci

    outputs.nixosModules.appimage
    outputs.nixosModules.common
    # outputs.nixosModules.docker # conflicts with `virtualisation.podman.dockerCompat`
    outputs.nixosModules.docs
    outputs.nixosModules.tailscale
    outputs.nixosModules.wine
  ];

  networking.hostName = "rv2";

  programs.steam.enable = true;

  programs.adb.enable = true;
  users.users.sid.extraGroups = [
    "adbusers"
    "kvm"
  ];

  services = {
    # FIXME:
    # connect in weechat:
    # /server add local localhost/6667
    # /set irc.server.local.password "abc"
    # /set irc.server.local.tls off
    # Access denied: Bad password?
    ngircd = {
      enable = true;
      config = ''
        [Global]
        Name = irc.local
        Info = Minimal ngIRCd Server
        Password = yourmom69
      '';
    };
    openssh.enable = true;
    windows-oci = {
      # enable = true;
      sharedVolume = "/home/sid/pub";
    };
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  normalUsers = {
    sid = {
      extraGroups = [
        "audio"
        "dialout"
        "floppy"
        "input"
        "libvirtd"
        "lp"
        "networkmanager"
        "video"
      ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "25.05";
}
