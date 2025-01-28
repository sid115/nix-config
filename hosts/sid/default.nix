{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix

    inputs.core.nixosModules.baibot
    inputs.core.nixosModules.common
    inputs.core.nixosModules.firefly-iii
    inputs.core.nixosModules.gitea
    inputs.core.nixosModules.mailserver
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.searx
    inputs.core.nixosModules.sops
    inputs.core.nixosModules.tt-rss

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  mailserver = {
    enable = true;
    loginAccounts = {
      "sid@${config.networking.domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/sid".path;
        aliases = [ "postmaster@${config.networking.domain}" ];
      };
    };
  };
  sops.secrets."mailserver/accounts/sid" = { };

  services = {
    openssh.enable = true;
    firefly-iii = {
      enable = true;
      subdomain = "finance";
    };
    gitea.enable = true;
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
    baibot = {
      enable = true;
      package = inputs.core.packages.${pkgs.system}.baibot;
    };
    nginx.enable = true;
    searx.enable = true;
    tt-rss.enable = true;
    open-webui.enable = true;
    open-webui.environment.ENABLE_OLLAMA_API = "False";
  };

  normalUsers = {
    sid = {
      name = "sid";
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ../../users/sid/pubkeys/gpg.pub
      ];
    };
  };

  system.stateVersion = "24.11";
}
