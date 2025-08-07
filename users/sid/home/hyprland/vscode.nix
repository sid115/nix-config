{ pkgs, ... }:

{
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        mkhl.direnv
        ms-vscode.cmake-tools
        ms-vscode.cpptools
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
