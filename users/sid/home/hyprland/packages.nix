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
      jitsi-meet-electron
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

      (instaloader.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ pkgs.python3Packages.browser-cookie3 ];
      }))
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
