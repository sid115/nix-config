{ config, lib, ... }:

let
  cfg = config.services.syncthing;
  guiPort = 8384;
  transferPort = 22000;
  fqdn = "sync.local";

  user = "sid";
  dirs = [
    "aud"
    "doc"
    "img"
    "vid"
  ];

  allDevices = {
    "16ach6" = {
      id = "5IPAQ5C-V3KFUMD-NJM74SH-6MD246O-JGYCBN4-F77QG6W-W3WNSCA-NQY37AY";
      addresses = [ "tcp://100.64.0.2:${toString transferPort}" ];
    };
    rv2 = {
      id = "JG6BYOJ-AW67R72-VA25U6I-VIZ57HU-3KXMPGY-HTYT2FQ-ZZL6U7B-Z2RWDQ4";
      addresses = [ "tcp://100.64.0.11:${toString transferPort}" ];
    };
    rx4 = {
      id = "SNZKKTO-HOTZM4Y-A63STRI-EHGQ6VI-3VTVINH-EYW5E3G-XEVJNBP-3XLE6AX";
      addresses = [ "tcp://100.64.0.10:${toString transferPort}" ];
    };
  };

  inherit (lib) filterAttrs genAttrs mkIf;
  inherit (builtins) attrNames toString;
in
{
  services.syncthing = {
    enable = true;
    inherit user;
    group = config.users.users.${user}.group;
    dataDir = config.users.users.${user}.home;

    guiAddress = "0.0.0.0:${toString guiPort}";
    guiPasswordFile = config.sops.secrets."syncthing/gui-pw".path;
    openDefaultPorts = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = filterAttrs (n: v: n != config.networking.hostName) allDevices;
      folders = genAttrs dirs (dir: {
        path = "${config.users.users.${user}.home}/${dir}";
        devices = attrNames cfg.settings.devices;
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
    ${config.services.tailscale.interfaceName}.allowedTCPPorts = [ guiPort ];
  };

  networking.hosts."127.0.0.1" = [ fqdn ];

  services.nginx = {
    enable = true;
    virtualHosts."${fqdn}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString guiPort}";
        proxyWebsockets = true;
      };
    };
  };

  sops.secrets."syncthing/gui-pw" = {
    owner = cfg.user;
    group = cfg.group;
    mode = "0400";
    restartUnits = [ "syncthing.service" ];
  };
}
