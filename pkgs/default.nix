{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  gitingest = pkgs.python3Packages.callPackage ./gitingest { };
  open-webui-desktop = pkgs.callPackage ./open-webui-desktop { };
  otp = pkgs.callPackage ./otp { };
  pdf2printable = pkgs.callPackage ./pdf2printable { };
  transcribe = pkgs.callPackage ./transcribe { };
  udiskie-dmenu = pkgs.callPackage ./udiskie-dmenu { };
  yt2rss = pkgs.callPackage ./yt2rss { };

  # spotify-to-tidal = pkgs.callPackage ./spotify-to-tidal { }; # FIXME
}
