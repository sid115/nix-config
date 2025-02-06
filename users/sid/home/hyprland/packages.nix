{ inputs, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      drawio
      gimp
      inkscape
      jan
      jellyfin-media-player
      mermaid-cli
      octaveFull
      pdfarranger
      remmina
      spotify # try programs.spotify-player
      texliveFull
      wineWowPackages.waylandFull
      zoom-us

      local.chatbox
    ]
    # tools
    ++ [
      aichat
      duden
      gptfdisk
      localsend
      magic-wormhole
      naabu
      ocrmypdf
      p7zip
      rclone
      speedtest-cli
      subfinder
      yt-dlp

      core.gitingest
    ]
    # reverse engineering
    ++ [
      checksec
      ghidra-bin
      ida-free
    ]
    # android
    ++ [
      adbfs-rootless
      android-tools
      scrcpy
    ];
}
