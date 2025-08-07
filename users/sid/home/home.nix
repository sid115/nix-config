{
  home = {
    username = "sid";

    shellAliases = {
      search-store = "find /nix/store -maxdepth 1 -type d | rg -i";
    };

    stateVersion = "24.11";
  };
}
