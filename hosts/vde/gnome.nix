{ pkgs, ... }:

{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    baobab
    epiphany
    evince
    geary
    gnome-backgrounds
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-disk-utility
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-software
    gnome-text-editor
    gnome-tour
    gnome-user-docs
    gnome-weather
    orca
    simple-scan
    snapshot
    totem
    yelp
  ];
}
