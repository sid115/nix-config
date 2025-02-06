{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  chatbox = pkgs.callPackage ./chatbox { };
  pdf2printable = pkgs.callPackage ./pdf2printable { };
  udiskie-dmenu = pkgs.callPackage ./udiskie-dmenu { };
}
