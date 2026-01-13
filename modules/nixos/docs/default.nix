{ pkgs, ... }:

{
  documentation = {
    dev.enable = true;
    man = {
      man-db.enable = true;
      mandoc.enable = false;
      generateCaches = true;
    };
  };

  environment.systemPackages = with pkgs; [
    core.cppman
    core.pyman
    man-pages
    man-pages-posix
  ];
}
