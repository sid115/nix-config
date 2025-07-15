{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      audacity
      cinny-desktop
      drawio
      gimp
      inkscape
      jellyfin-media-player
      kicad
      mermaid-cli
      octaveFull
      pdfarranger
      remmina
      spotify
      texliveFull
      wineWowPackages.waylandFull
      zotero

      core.visual-paradigm-community
    ]
    # tools
    ++ [
      aichat
      compose2nix
      cutecom
      duden
      ftx-prog
      gf
      gitingest
      gptfdisk
      gtkterm
      instaloader
      localsend
      magic-wormhole
      naabu
      ocrmypdf
      p7zip
      rclone
      rustfmt
      showmethekey
      speedtest-cli
      subfinder
      xxd
      yt-dlp

      core.marker-pdf
      local.otp
      local.pdf2printable
      local.transcribe
      local.yt2rss
    ]
    # reverse engineering
    # ++ [
    #   checksec
    #   ghidra-bin
    #   ida-free
    # ]
    # android
    ++ [
      adbfs-rootless
      android-tools
      scrcpy
    ];
}
