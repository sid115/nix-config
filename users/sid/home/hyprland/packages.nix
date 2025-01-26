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
    ]
    # tools
    ++ [
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

      inputs.core.packages.${pkgs.system}.gitingest
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
