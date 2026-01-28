{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.tailscale ];

  services.tailscale = {
    enable = true;
    enableSSH = true;
    loginServer = "https://hs.sid.ovh";
  };
}
