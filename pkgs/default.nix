{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  udiskie-dmenu = pkgs.callPackage ./udiskie-dmenu { };
}
