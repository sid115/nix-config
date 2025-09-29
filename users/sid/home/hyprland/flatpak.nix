{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    packages = [
      {
        appId = "org.mypaint.MyPaint";
        origin = "flathub";
      }
      {
        appId = "us.zoom.Zoom";
        origin = "flathub";
      }
    ];
  };

  home.packages = [ pkgs.flatpak ];
}
