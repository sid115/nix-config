{ inputs, lib, ... }:

{
  imports = [
    inputs.core.homeModules.styling
  ];

  styling = {
    enable = true;
    scheme = "oxocarbon";
  };
  stylix.image = lib.mkForce null;
}
