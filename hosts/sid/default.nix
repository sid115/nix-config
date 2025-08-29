{
  inputs,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./maubot.nix
    ./packages.nix

    ../../users/sid

    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.common
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ntfy-sh
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  services = {
    baibot = {
      enable = true;
      package = pkgs.core.baibot;
    };
    openssh.enable = true;
    matrix-synapse = {
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
    nginx = {
      enable = true;
    };
    ntfy-sh = {
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
              "ig"
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
  };

  system.stateVersion = "24.11";
}
