{ inputs, config, ... }:

{
  imports = [
    inputs.core.homeModules.nextcloud-sync
  ];

  services.nextcloud-sync =
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
      enable = true;
      remote = "cloud.portuus.de";
      passwordFile = config.sops.secrets.nextcloud.path;
      connections = mkConnections connections;
    };

  services.spotifyd = {
    enable = true;
    settings = {
      username = "zephyrius17";
      password_cmd = "cat ${config.sops.secrets.spotify.path}";
    };
  };
  sops.secrets.spotify = { };
}
