{ config, lib, ... }:

let
  cfg = config.services.syncthing;
  port = 8384;

  user = "sid";
  dirs = [
    "aud"
    "doc"
    "img"
    "vid"
  ];

  inherit (lib) genAttrs mkIf;
  inherit (builtins) toString;
in
{
  services.syncthing = {
    enable = true;
    inherit user;
    group = config.users.users.${user}.group;
    dataDir = config.users.users.${user}.home;

    guiAddress = "0.0.0.0:${toString port}";
    guiPasswordFile = config.sops.secrets."syncthing/gui-pw".path;
    openDefaultPorts = true;

    settings = {
      folders = genAttrs dirs (dir: {
        path = "${config.users.users.${user}.home}/${dir}";
      });

      gui = {
        inherit user;
      };
      options = {
        urAccepted = -1; # disable usage reports
      };
    };
  };

  networking.firewall.interfaces = mkIf config.services.tailscale.enable {
    ${config.services.tailscale.interfaceName}.allowedTCPPorts = [ port ];
  };

  sops.secrets."syncthing/gui-pw" = {
    owner = cfg.user;
    group = cfg.group;
    mode = "0400";
    restartUnits = [ "syncthing.service" ];
  };
}
