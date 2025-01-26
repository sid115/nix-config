{ config, ... }:

let
  sops = config.sops;
in
{
  sops.templates.rclone.path = config.xdg.configHome + "/rclone/rclone.conf";
  sops.templates.rclone.content = ''
    [portuus]
    type = webdav
    url = https://cloud.portuus.de/remote.php/dav/files/sid/
    vendor = nextcloud
    user = sid
    pass = ${sops.placeholder."rclone/portuus/pass"}

    [sciebo]
    type = webdav
    url = ${sops.placeholder."rclone/sciebo/url"}
    vendor = owncloud
    user = ${sops.placeholder."rclone/sciebo/user"}
    pass = ${sops.placeholder."rclone/sciebo/pass"}
  '';

  sops.secrets."rclone/portuus/pass" = { };
  sops.secrets."rclone/sciebo/pass" = { };
  sops.secrets."rclone/sciebo/url" = { };
  sops.secrets."rclone/sciebo/user" = { };
}
