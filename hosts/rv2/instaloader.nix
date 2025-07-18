{ inputs, config, ... }:

let
  cfg = config.services.instaloader;
in
{
  imports = [
    inputs.core.nixosModules.instaloader
    inputs.core.nixosModules.sops
  ];

  services.instaloader = {
    enable = true;
    login = "igportuus";
    passwordFile = config.sops.secrets.instaloader.path;
    timer.onCalendar = "hourly";
    profiles = [
      "kalteliebelive"
      "kukocologne"
      "tham.bln"
    ];
  };

  sops.secrets.instaloader = {
    owner = cfg.user;
    group = cfg.group;
    mode = "0600";
  };
}
