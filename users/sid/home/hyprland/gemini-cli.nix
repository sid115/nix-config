{ config, ... }:

{
  programs.gemini-cli = {
    enable = true;
  };

  sops.templates.gemini-cli-env = {
    content = ''
      GEMINI_API_KEY=${config.sops.placeholder.gemini-api-key}
    '';
    path = config.home.homeDirectory + "/.gemini/.env";
  };
}
