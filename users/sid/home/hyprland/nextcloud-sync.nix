{ inputs, config, ... }:

let
  mkConnection = dir: {
    local = config.home.homeDirectory + "/" + dir;
    remote = "/" + dir;
  };

  mkConnections = dirs: map mkConnection dirs;

  connections = [
    "aud"
    "doc"
    "img"
    "vid"
  ];
in
{
  imports = [
    inputs.core.homeModules.nextcloud-sync
  ];

  services.nextcloud-sync = {
    enable = true;
    remote = "cloud.portuus.de";
    passwordFile = config.sops.secrets.nextcloud.path;
    connections = mkConnections connections;
  };
}
