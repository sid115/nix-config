{ inputs, pkgs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

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
        appId = "us.zoom.Zoom";
        origin = "flathub";
      }
    ];
  };

  # https://github.com/gmodena/nix-flatpak/issues/156
  home.packages = [ pkgs.flatpak ];
}
