{ pkgs, ... }:

let
  fzf-dirs = "~/doc ~/img ~/aud ~/dls ~/src ~/.config ~/.local";

  fzf-open = pkgs.writeShellScriptBin "fzf-open" ''
    fzf --preview="pistol {}" --bind "enter:execute(hyprctl dispatch togglespecialworkspace fzf-open && xdg-open {} > /dev/null 2>&1 &)"
  '';
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mod, Space, togglespecialworkspace, fzf-open"
      ];
      windowrulev2 = [
        "float, class:floating"
        "size 50% 50%, title:fzf-open"
      ];
    };
    extraConfig = ''
      workspace = special:fzf-open, on-created-empty:kitty --class=floating -e ${fzf-open}/bin/fzf-open
    '';
  };

  home = {
    sessionVariables = {
      # FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' ${fzf-dirs}";
      FZF_DEFAULT_COMMAND = "rg --files ${fzf-dirs}";
    };
    packages = [
      fzf-open
    ];
  };
}
