{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      audacity
      drawio
      gimp
      inkscape
      jitsi-meet-electron
      ladybird
      mermaid-cli
      octaveFull
      pdfarranger
      remmina
      spotify
      texliveFull
      wineWowPackages.waylandFull
      zotero

      # jellyfin-media-player # qtwebengine-5.15.19 is marked as insecure
      # kicad # FIXME
      # core.visual-paradigm-community # FIXME
    ]
    # tools
    ++ [
      aichat
      compose2nix
      cutecom
      duden
      ftx-prog
      gf
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
      synadm
      tmux
      xxd
      yt-dlp

      (instaloader.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
          python3Packages.browser-cookie3
        ];
      }))

      # core.marker-pdf # FIXME
      local.gitingest # TODO: PR Nixpkgs
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
