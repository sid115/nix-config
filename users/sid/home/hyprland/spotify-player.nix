{ config, ... }:

{
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

  services.spotifyd = {
    enable = true;
    settings = {
      username = "zephyrius17";
      password_cmd = "cat ${config.sops.secrets.spotify.path}";
    };
  };
}
