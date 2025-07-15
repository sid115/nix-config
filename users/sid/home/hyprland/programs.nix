{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.homeModules.gemini-cli
  ];

  programs.gemini-cli = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    # TODO: set GH_TOKEN with sops
  };

  programs.librewolf = {
    profiles.default.extensions.packages =
      with inputs.nur.legacyPackages."${pkgs.system}".repos.rycee.firefox-addons; [
        zotero-connector
      ];
  };

  programs.newsboat = {
    extraConfig = ''
      urls-source "ttrss"
      ttrss-url "https://tt-rss.portuus.de/"
      ttrss-login "sid"
      ttrss-passwordfile "${config.sops.secrets.tt-rss.path}"
    '';
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.opencode = {
    enable = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      theme = "opencode";
      provider = {
        openrouter = {
          name = "OpenRouter";
          api_key = "{file:${config.sops.secrets.openrouter-api-key.path}}";
          models = {
            "google/gemini-2.5-flash" = {
              name = "Gemini 2.5 Flash";
            };
          };
        };
      };
      model = "openrouter/google/gemini-2.5-flash";
      autoshare = false;
      autoupdate = false;
    };
  };

  programs.waybar.settings = {
    mainBar = {
      modules-right = [
        "custom/timer"
        "custom/newsboat"
        "network"
        "bluetooth"
        "cpu"
        "memory"
        "disk"
        "pulseaudio#input"
        "pulseaudio#output"
        "battery"
        "tray"
      ];
    };
  };

  programs.spotify-player = {
    enable = true;
    # package = pkgs.spotify-player.override {
    #   withImage = false;
    #   withSixel = false;
    # };
    settings = {
      actions = [
        {
          command = "GoToArtist";
          key_sequence = "g A";
        }
        {
          command = "GoToAlbum";
          key_sequence = "g B";
          target = "PlayingTrack";
        }
      ];
      pause_icon = " ";
      play_icon = " ";
      device = {
        audio_cache = true;
        autoplay = true;
        normalization = true;
        volume = 100;
      };
      layout = {
        playback_window_position = "Bottom";
        library = {
          playlist_percent = 80;
          album_percent = 0;
        };
      };
    };
  };

  # VSC
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        ms-vscode.cmake-tools
        ms-vscode.cpptools
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  programs.zathura.package = pkgs.old-old-stable.zathura; # https://github.com/pwmt/zathura/issues/447
}
