{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.headscale
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ntfy-sh
    inputs.core.nixosModules.openssh
  ];

  services.baibot = {
    enable = true;
    package = pkgs.core.baibot;
  };

  services.headscale = {
    enable = true;
    openFirewall = true;
    subdomain = "hs";
  };

  services.matrix-synapse = {
    enable = true;
    bridges = {
      whatsapp = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
      signal = {
        enable = true;
        admin = "@sid:sid.ovh";
      };
    };
  };

  services.nginx.enable = true;

  services.ntfy-sh = {
    enable = true;
    reverseProxy.enable = true;
    settings.base-url = "https://ntfy.sid.ovh";
    notifiers = {
      monitor-domains =
        let
          subdomains = [
            "ai"
            "cloud"
            "dav"
            "finance"
            "import.finance"
            "git"
            "grafana"
            "hydra"
            "media"
            "office"
            "rss-bridge"
            # "search" # FIXME: 429
            "share"
            "tt-rss"
            "vault"
            "vde"
            "videos"
          ];
        in
        map (subdomain: {
          fqdn = subdomain + ".portuus.de";
          topic = "portuus";
        }) subdomains;
    };
  };

  services.openssh.enable = true;
}
