{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.headplane
    inputs.core.nixosModules.headscale
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ntfy-sh
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.uptime-kuma
    inputs.core.nixosModules.uptime-kuma-agent

    outputs.nixosModules.tailscale

    ./maubot.nix
  ];

  services.baibot = {
    enable = true;
    package = pkgs.core.baibot;
  };

  services.headplane = {
    enable = true;
    subdomain = "hp";
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

  services.nginx = {
    enable = true;
    virtualHosts."ai.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/.well-known/acme-challenge" = {
        extraConfig = ''
          default_type "text/plain";
        '';
      };
      locations."/" = {
        proxyPass = "http://100.64.0.5:8081";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
    virtualHosts."print.sid.ovh" = {
      enableACME = true;
      forceSSL = true;
      locations."/.well-known/acme-challenge" = {
        extraConfig = ''
          default_type "text/plain";
        '';
      };
      locations."/" = {
        proxyPass = "http://100.64.0.5:631";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

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

  # services.tailscale.loginServer = lib.mkForce (
  #   with config.services.headscale; "http://${address}.${toString port}"
  # );

  services.uptime-kuma = {
    enable = true;
    subdomain = "kuma";
  };

  services.uptime-kuma-agent = {
    enable = true;
    monitors = {
      nginx = {
        secretFile = config.sops.secrets."uptime-kuma-agent/nginx".path;
      };
      matrix-synapse = {
        secretFile = config.sops.secrets."uptime-kuma-agent/matrix-synapse".path;
      };
      mautrix-whatsapp = {
        secretFile = config.sops.secrets."uptime-kuma-agent/mautrix-whatsapp".path;
      };
      mautrix-signal = {
        secretFile = config.sops.secrets."uptime-kuma-agent/mautrix-signal".path;
      };
    };
  };
}
