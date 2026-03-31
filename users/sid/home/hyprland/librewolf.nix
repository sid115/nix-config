{ inputs, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  programs.librewolf = {
    profiles.default.extensions.packages =
      with inputs.nur.legacyPackages."${system}".repos.rycee.firefox-addons; [
        zotero-connector
      ];
  };
}
