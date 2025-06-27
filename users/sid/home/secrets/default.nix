{ config, ... }:

{
  sops.secrets.github-token = { };
  sops.templates.access-tokens.content = ''
    access-tokens = github.com=${config.sops.placeholder.github-token}
  '';

  sops.secrets.nextcloud = { };
  sops.secrets.openrouter-api-key = { };
  sops.secrets.tt-rss = { };

  sops.secrets.gemini-api-key = { };
  sops.templates.gemini-cli-env = {
    content = ''
      GEMINI_API_KEY=${config.sops.placeholder.gemini-api-key}
    '';
    path = config.home.homeDirectory + "/.gemini/.env";
  };
}
