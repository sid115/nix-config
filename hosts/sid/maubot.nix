{ config, ... }:

# Setup:
# Create bot: $ register_new_matrix_user
# Login as your admin user: $ mbc login
# Authenticate as bot: $ mbc auth
# Take not of access token and device ID
# Visit https://sid.ovh/_matrix/maubot
# Create a client (if not already preset)
# Create an instance
# TODO: Set homeserver secret

let
  cfg = config.services.maubot;
  matrix = config.services.matrix-synapse;
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  services.maubot = {
    enable = true;
    extraConfigFile = config.sops.templates."maubot/extra-config-file".path;
    plugins = with cfg.package.plugins; [
      github
      reminder
    ];
    settings = {
      # homeservers = with matrix.settings; {
      #   "${server_name}" = {
      #     url = "${public_baseurl}/_matrix/client/v3";
      #   };
      # };
      server.public_url = matrix.settings.public_baseurl;
      plugin_directories = with config.users.users.maubot; {
        upload = home + "/plugins";
        load = [ (home + "/plugins") ];
        trash = home + "/trash";
      };
      plugin_databases = with config.users.users.maubot; {
        sqlite = home + "/plugins";
      };
      # logging = with config.users.users.maubot; {
      #   handlers.file.filename = home + "/maubot.log";
      # };
    };
  };

  environment.systemPackages = [
    cfg.package
  ];

  systemd.tmpfiles.rules = with cfg.settings.plugin_directories; [
    "d ${upload} 0755 maubot maubot -"
    "d ${trash} 0755 maubot maubot -"
  ];

  services.nginx.virtualHosts."${matrix.settings.server_name}".locations = {
    "^~ /_matrix/maubot/" = {
      proxyPass = with cfg.settings.server; "http://${hostname}:${toString port}";
      proxyWebsockets = true;
    };
    "^~ /_matrix/maubot/v1/logs" = {
      proxyPass = with cfg.settings.server; "http://${hostname}:${toString port}";
      proxyWebsockets = true;
    };
  };

  sops =
    let
      owner = "maubot";
      group = "maubot";
      mode = "0440";
    in
    {
      secrets."maubot/admins/sid" = {
        inherit owner group mode;
      };
      templates."maubot/extra-config-file" = {
        inherit owner group mode;
        content = ''
          homeservers:
              ${matrix.settings.server_name}:
                  url: http://localhost:8008
                  secret: ${config.sops.placeholder."matrix/registration-shared-secret"}
          admins:
              sid: ${config.sops.placeholder."maubot/admins/sid"}
        '';
      };
    };
}
