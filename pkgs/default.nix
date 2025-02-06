{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  chatbox = pkgs.callPackage ./chatbox { };
  udiskie-dmenu = pkgs.callPackage ./udiskie-dmenu { };
}
