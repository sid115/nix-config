{ pkgs, ... }:

{
  documentation = {
    dev.enable = true;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.core.cppman
    pkgs.core.pyman
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
