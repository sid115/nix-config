{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.print-server ];

  services.print-server = {
    enable = true;
    forceSSL = false;
  };
}
