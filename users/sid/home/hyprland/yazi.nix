{ pkgs, lib, ... }:

{
  programs.yazi =
    let
      hide-yazi-workspace = pkgs.writeShellScript "hide-yazi-workspace.sh" ''
        (hyprctl monitors -j | ${lib.getExe pkgs.jq} -e 'any(.specialWorkspace.name == "special:yazi")' > /dev/null) && hyprctl dispatch togglespecialworkspace yazi
      '';
    in
    {
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "o";
            run = [
              "shell --orphan ${hide-yazi-workspace}"
              "open"
            ];
            desc = "";
          }
        ];
      };
    };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      workspace = special:yazi, on-created-empty:kitty -T yazi -e yazi
      bind = $mod, x, togglespecialworkspace, yazi
      windowrule = float, title:^yazi$
      windowrule = size 50% 50%, title:^yazi$
    '';
  };
}
