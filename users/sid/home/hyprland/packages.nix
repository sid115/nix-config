{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      audacity
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
      zotero
    ]
    # tools
    ++ [
      aichat
      compose2nix
      duden
      gptfdisk
      instaloader
      localsend
      magic-wormhole
      naabu
      ocrmypdf
      p7zip
      rclone
      rustfmt
      speedtest-cli
      subfinder
      yt-dlp

      core.gitingest
      core.marker-pdf
      local.otp
      local.pdf2printable
      local.transcribe
      local.yt2rss
      unstable.ftx-prog
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
