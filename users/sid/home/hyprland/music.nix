{ config, pkgs, ... }:

let
  sops = config.sops;
  musicDir = config.xdg.userDirs.music;
in
{
  programs.ncmpcpp = {
    # package = pkgs.ncmpcpp.override {
    #   outputsSupport = true;
    #   visualizerSupport = true;
    #   clockSupport = true;
    #   taglibSupport = true;
    # };
    mpdMusicDir = musicDir;
    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
    };
  };

  services.mpd = {
    musicDirectory = musicDir;
  };

  services.mopidy = {
    enable = true;
    settings = {
      # jellyfin = {
      #   enabled = true;
      #   username = "sid@portuus.de";
      #   hostname = "https://media.portuus.de";
      #   libraries = [ "Music" ];
      # };
      # local = {
      #   enabled = true;
      #   media_dir = musicDir;
      # };
      mpd = {
        enabled = true;
        hostname = "127.0.0.1";
      };
      spotify = {
        enabled = true;
      };
      ytmusic = {
        enabled = true;
      };
    };
    extensionPackages = with pkgs; [
      # mopidy-bandcamp
      mopidy-iris
      # mopidy-jellyfin
      # mopidy-local
      mopidy-mpd
      # mopidy-soundcloud
      mopidy-spotify
      # mopidy-tidal
      mopidy-ytmusic
    ];
    extraConfigFiles = with sops.templates; [
      # jellyfin.path
      # soundcloud.path
      spotify.path
      # tidal.path
    ];
  };

  sops = {
    # templates.jellyfin.content = ''
    #   [jellyfin]
    #   password = ${sops.placeholder."jellyfin/password"}
    # '';
    # templates.soundcloud.content = ''
    #   [soundcloud]
    #   auth_token = ${sops.placeholder."soundcloud/auth_token"}
    # '';
    templates.spotify.content = ''
      [spotify]
      client_id = ${sops.placeholder."spotify/client_id"}
      client_secret = ${sops.placeholder."spotify/client_secret"}
    '';
    # templates.tidal.content = ''
    #   [tidal]
    #   client_id = ${sops.placeholder."tidal/client_id"}
    #   client_secret = ${sops.placeholder."tidal/client_secret"}
    # '';

    # secrets."jellyfin/password" = { };
    # secrets."soundcloud/auth_token" = { };
    secrets."spotify/client_id" = { };
    secrets."spotify/client_secret" = { };
    # secrets."tidal/client_id" = { };
    # secrets."tidal/client_secret" = { };
  };
}
