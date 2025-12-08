{ inputs, ... }:

{
  imports = [
    inputs.core.homeModules.sops
  ];

  sops.secrets = {
    "rclone/portuus/pass" = { };
    "rclone/sciebo/pass" = { };
    "rclone/sciebo/url" = { };
    "rclone/sciebo/user" = { };
    gemini-api-key = { };
    github-token = { };
    nextcloud = { };
    openrouter-api-key = { };
    spotify = { };
    miniflux = { };
  };
}
