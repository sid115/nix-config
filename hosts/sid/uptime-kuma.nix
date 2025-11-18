{ config, ... }:

let
  cfg = config.services.uptime-kuma;
  domain = config.networking.domain;
  fqdn = "kuma.${domain}";
in
{
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      PORT = "3001";
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = with cfg.settings; "http://${HOST}:${PORT}";
    };
  };
}
