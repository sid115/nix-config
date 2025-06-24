{ config, ... }:

{
  services.recoll = {
    enable = true;
    configDir = "${config.xdg.configHome}/recoll";
    settings = {
      nocjk = true;
      loglevel = 5;
      topdirs = [
        "~/aud"
        "~/dls"
        "~/doc"
        "~/img"
        "~/src"
      ];

      "~/dls" = {
        "skippedNames+" = [ "*.iso" ];
      };

      "~/src" = {
        "skippedNames+" = [
          "node_modules"
          "target"
          "result"
        ];
      };
    };
  };
}
