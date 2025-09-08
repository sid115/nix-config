{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    bitwarden-menu
  ];

  programs.librewolf.profiles.default.extensions.packages =
    with inputs.nur.legacyPackages."${pkgs.system}".repos.rycee.firefox-addons; [
      bitwarden
    ];
}
