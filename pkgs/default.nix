{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  chatbox = pkgs.callPackage ./chatbox { };
  otp = pkgs.callPackage ./otp { };
  pdf2printable = pkgs.callPackage ./pdf2printable { };
  udiskie-dmenu = pkgs.callPackage ./udiskie-dmenu { };
  yt2rss = pkgs.callPackage ./yt2rss { };
}
