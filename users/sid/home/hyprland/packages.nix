{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      drawio
      gimp
      inkscape
      jellyfin-media-player
      mermaid-cli
      octaveFull
      pdfarranger
      remmina
      spotify
      texliveFull
      wineWowPackages.waylandFull
      zoom-us
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
      core.marker-pdf
      local.pdf2printable
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
