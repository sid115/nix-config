{ config, ... }:

{
  programs.newsboat = {
    extraConfig = ''
      urls-source "miniflux"
      miniflux-url "https://miniflux.portuus.de/"
      miniflux-login "sid"
      miniflux-passwordfile "${config.sops.secrets.miniflux.path}"
    '';
  };
}
