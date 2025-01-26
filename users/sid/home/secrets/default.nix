{ config, ... }:

{
  sops.secrets.github-token = { };
  sops.templates.access-tokens.content = ''
    access-tokens = github.com=${config.sops.placeholder.github-token}
  '';

  sops.secrets.nextcloud = { };
  sops.secrets.tt-rss = { };
}
