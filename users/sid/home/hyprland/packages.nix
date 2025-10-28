{ inputs, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      angryipscanner
      audacity
      autopsy
      discord
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
      teams-for-linux
      texliveFull
      xournalpp
      zotero

      # inputs.gen-dmc.packages.${pkgs.system}.gen-dmc

      # core.visual-paradigm-community # FIXME
      # jellyfin-media-player # qtwebengine-5.15.19 is marked as insecure
      # kicad # FIXME
    ]
    # tools
    ++ [
      aichat
      compose2nix
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

      inputs.multios-usb.packages.${pkgs.system}.default

      (instaloader.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
          python3Packages.browser-cookie3
        ];
      }))

      local.gitingest # TODO: PR Nixpkgs
      local.otp
      local.pdf2printable
      local.transcribe
      local.yt2rss

      core.bulk-rename
      # core.marker-pdf # FIXME
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
