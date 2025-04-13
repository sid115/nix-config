# `zathura_core` is not a toplevel package, threfore `prev.zathura_core` is not available
# Maybe `overrideScope` is needed: overrideScope = (scope -> scope -> AttrSet) -> scope
# But I don't know how to use it.
# zathura package definition: https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/applications/misc/zathura/default.nix

final: prev: {
  # error: attribute 'overrideScope' missing
  zathura = prev.zathura.overrideScope {
    zathura_core = prev.zathura_core.overrideAttrs (oldAttrs: rec {
      version = "0.5.4"; # latest version before https://github.com/pwmt/zathura/issues/447
      src = prev.fetchFromGitHub {
        owner = "pwmt";
        repo = "zathura";
        rev = version;
        hash = "";
      };
    });
  };
}
