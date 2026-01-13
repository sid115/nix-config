{ inputs, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home.packages =
    with pkgs;
    [
      audacity
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
      weechat
      xournalpp
      zotero

      # inputs.gen-dmc.packages."${system}".gen-dmc

      # angryipscanner # FIXME
      # autopsy # gradle-7.6.6 is marked as insecure
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
      glab
      gtkterm
      localsend
      magic-wormhole
      naabu
      ocrmypdf
      rpi-imager
      rustfmt
      showmethekey
      songrec
      speedtest-cli
      subfinder
      synadm
      yt-dlp

      inputs.multios-usb.packages."${system}".default

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
