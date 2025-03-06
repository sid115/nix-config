{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      evtest
      linuxConsoleTools
    ];
  };
}
