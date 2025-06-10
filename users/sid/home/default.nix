{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./secrets

    inputs.core.homeModules.common
    inputs.core.homeModules.nixvim
    inputs.core.homeModules.sops

    outputs.homeModules.common
  ];

  home.username = "sid";

  programs.git = {
    enable = true;
    userName = "sid";
    userEmail = "sid@portuus.de";
  };

  programs.nixvim = {
    enable = true;
    plugins = {
      avante = {
        enable = true;
        autoLoad = true;
        settings = {
          selector.provider = "telescope";
          auto_suggestions_provider = null;
          provider = "openrouter";
          providers = {
            openrouter = {
              __inherited_from = "openai";
              endpoint = "https://openrouter.ai/api/v1";
              api_key_name = "cmd:cat ${config.sops.secrets.openrouter-api-key.path}";
              model = "google/gemini-2.5-flash-preview-05-20";
            };
          };
        };
      };
      render-markdown = {
        enable = true;
        settings = {
          file_types = [
            "Avante"
          ];
        };
      };
      which-key.enable = true;
      # cmp-nvim-ultisnips.enable = true;
    };
  };

  programs.zsh.initContent = builtins.readFile ./cdf.sh;

  # xdg might not be available, hence `home.file`
  home.file.nixpkgs_config = {
    target = ".config/nixpkgs/config.nix";
    text = ''
      { allowUnfree = true; }
    '';
  };

  home.shellAliases = {
    search-store = "find /nix/store -maxdepth 1 -type d | rg -i";
  };

  # Nix access tokens
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    !include ${config.sops.templates.access-tokens.path}
  '';
  # If tokens got updated, remove old ones:
  # sudo rm -f /home/sid/.config/sops-nix/secrets/rendered/access-tokens

  home.stateVersion = "24.11";
}
