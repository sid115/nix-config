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
      jitsi-meet-electron
      kicad
      ladybird
      mermaid-cli
      octaveFull
      pdfarranger
      remmina
      spotify
      texliveFull
      wineWowPackages.waylandFull
      zotero

      # core.visual-paradigm-community
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
      songrec
      speedtest-cli
      subfinder
      tmux
      xxd
      yt-dlp

      (instaloader.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
          python3Packages.browser-cookie3
        ];
      }))

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
      android-studio
      android-studio-tools
      android-tools
      scrcpy
    ];

  nixpkgs.config = {
    android_sdk.accept_license = true; # for android-studio
  };
}
