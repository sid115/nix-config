{ inputs, pkgs, ... }:

{
  programs.librewolf = {
    profiles.default.extensions.packages =
      with inputs.nur.legacyPackages."${pkgs.system}".repos.rycee.firefox-addons; [
        zotero-connector
      ];
  };
}
