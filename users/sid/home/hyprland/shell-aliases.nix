{ pkgs, ... }:

{
  home.shellAliases = {
    bt = "bluetoothctl";
    ff = "find . -type f -name";
    dd-iso = "dd bs=4M status=progress oflag=sync";
    nc-sync = "nextcloud-sync-all";
    synapse_change_display_name = "${pkgs.core.synapse_change_display_name}/bin/synapse_change_display_name -t $(${pkgs.pass}/bin/pass sid.ovh/matrix/access-token) -r sid.ovh";
  };
}
