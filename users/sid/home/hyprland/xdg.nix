{ config, ... }:

{
  xdg.userDirs =
    let
      homeDir = config.home.homeDirectory;
    in
    {
      desktop = "${homeDir}";
      documents = "${homeDir}/doc";
      download = "${homeDir}/dls";
      music = "${homeDir}/aud/music";
      pictures = "${homeDir}/img";
      publicShare = "${homeDir}";
      templates = "${homeDir}";
      videos = "${homeDir}/vid";
    };
}
