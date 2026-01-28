{
  home = {
    username = "sid";

    shellAliases = {
      gpr = "git remote prune origin";
      search-store = "find /nix/store -maxdepth 1 -type d | rg -i";
    };

    stateVersion = "24.11";
  };
}
