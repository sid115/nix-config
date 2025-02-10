{
  config,
  pkgs,
  ...
}:

{
  programs.newsboat = {
    extraConfig = ''
      urls-source "ttrss"
      ttrss-url "https://tt-rss.sid.ovh/"
      ttrss-login "sid"
      ttrss-passwordfile "${config.sops.secrets.tt-rss.path}"
    '';
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
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
    actions = [
      {
        action = "GoToArtist";
        key_sequence = "g A";
      }
      {
        action = "GoToAlbum";
        key_sequence = "g B";
        target = "PlayingTrack";
      }
    ];
  };

  # VSC
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
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
}
