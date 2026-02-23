{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.forgejo-runner;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.services.forgejo-runner = {
    enable = mkEnableOption "Nix-based Forgejo Runner service";
    url = mkOption {
      type = types.str;
      description = "Forgejo instance URL.";
    };
    tokenFile = mkOption {
      type = types.path;
      description = "Path to EnvironmentFile containing TOKEN=...";
    };
    label = mkOption {
      type = types.str;
      default = "host";
      description = "Runner label.";
    };
  };

  config = mkIf cfg.enable {
    nix.settings.trusted-users = [ "gitea-runner" ];

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = "${config.networking.hostName}-nix";
        inherit (cfg) url tokenFile;

        labels = [ "${cfg.label}:host" ];

        hostPackages = with pkgs; [
          bash
          coreutils
          curl
          deploy-rs
          gitMinimal
          gnused
          nix
          nodejs
          openssh
          sudo
          tailscale
        ];

        settings = {
          log.level = "info";
          runner = {
            capacity = 4;
            envs = {
              NIX_CONFIG = "extra-experimental-features = nix-command flakes";
              NIX_REMOTE = "daemon";
            };
          };
        };
      };
    };
  };
}
