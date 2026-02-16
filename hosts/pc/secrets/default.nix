{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];
}
