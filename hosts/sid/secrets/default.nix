{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets."uptime-kuma-agent/nginx" = { };
  sops.secrets."uptime-kuma-agent/matrix-synapse" = { };
  sops.secrets."uptime-kuma-agent/mautrix-whatsapp" = { };
  sops.secrets."uptime-kuma-agent/mautrix-signal" = { };
}
