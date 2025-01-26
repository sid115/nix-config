{ inputs, ... }:

let
  key.a.grip = "F8BCC76BE2E55D52C3E92B963ADD3FDD8C153911";
  key.e.id = "97BEF39E76001BC0";
in
{
  imports = [ inputs.core.homeModules.gpg ];

  services.gpg-agent.sshKeys = [ key.a.grip ];
  programs.passwordManager.key = key.e.id;
}
