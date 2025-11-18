{
  inputs,
  config,
  ...
}:

let
  cfg = config.services.headplane;
  domain = config.networking.domain;
  fqdn = "hp.${domain}";
  headscale = config.services.headscale;
in
{
  imports = [ inputs.headplane.nixosModules.headplane ];

  nixpkgs.overlays = [
    inputs.headplane.overlays.default
  ];

  services.headplane = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 3000;
      };
      headscale = {
        url = "http://127.0.0.1:${toString headscale.port}";
        public_url = headscale.settings.server_url;
        config_path = "/etc/headscale/config.yaml";
      };
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = with cfg.settings.server; "http://${host}:${toString port}";
      proxyWebsockets = true;
    };
  };
}
