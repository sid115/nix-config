{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.ntfy-sh
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  networking.hostName = "sid";
  networking.domain = "sid.ovh";

  services = {
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
    nginx.enable = true;
    ntfy-sh = {
      enable = true;
      settings.base-url = "https://ntfy.sid.ovh";
      notifiers = {
        monitor-domains = [
          {
            fqdn = "cloud.portuus.de";
            topic = "portuus";
          }
        ];
      };
    };
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
