{
  inputs,
  config,
  pkgs,
  ...
}:

let
  mkDir = dir: {
    path = config.home.homeDirectory + "/" + dir;
    recurse = true;
  };

  mkDirs = dirs: map mkDir dirs;

  dirs = [
    "aud"
    "dls"
    "doc"
    "img"
    "src"
    "vid"
  ];

  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.kidex.homeModules.kidex
  ];

  programs.anyrun = {
    enable = true;
    package = inputs.anyrun.packages."${system}".anyrun-with-all-plugins;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = true;
      layer = "overlay";
      hidePluginInfo = true;
      showResultsImmediately = true;
      plugins = with inputs.anyrun.packages."${system}"; [
        applications
        dictionary
        kidex
        randr
        rink
        translate
        websearch
      ];
    };
    extraCss = ''
      #window {
        background-color: rgba(0, 0, 0, 0);
      }
    '';
    extraConfigFiles = {
      "dictionary.ron".text = ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';
      "translate.ron".text = ''
        Config(
          prefix: ":t",
          language_delimiter: ">",
          max_entries: 3,
        )
      '';
      "randr.ron".text = ''
        Config(
          prefix: ":dp",
          max_entries: 5,
        )
      '';
      # TODO: websearch.ron: set custom search engine
    };
  };

  services.kidex = {
    enable = true;
    settings = {
      ignored = [
        "*/.git/*"
        "*/.cache/*"
        "*/.direnv/*"
      ];
      directories = mkDirs dirs;
    };
  };

  wayland.windowManager.hyprland.settings.bind = [
    "$mod, space, exec, anyrun"
  ];
}
