{
  inputs,
  config,
  ...
}:

{
  imports = [ inputs.core.homeModules.nextcloud-sync ];

  services.nextcloud-sync = {
    enable = true;
    remote = "cloud.portuus.de";
    passwordFile = config.sops.secrets.nextcloud.path;
    connections = [
      {
        local = "/home/sid/aud";
        remote = "/aud";
      }
      {
        local = "/home/sid/doc";
        remote = "/doc";
      }
      {
        local = "/home/sid/img";
        remote = "/img";
      }
      {
        local = "/home/sid/vid";
        remote = "/vid";
      }
    ];
  };
}
