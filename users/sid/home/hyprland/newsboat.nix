{ config, ... }:

{
  programs.newsboat = {
    extraConfig = ''
      urls-source "ttrss"
      ttrss-url "https://tt-rss.portuus.de/"
      ttrss-login "sid"
      ttrss-passwordfile "${config.sops.secrets.tt-rss.path}"
    '';
  };
}
