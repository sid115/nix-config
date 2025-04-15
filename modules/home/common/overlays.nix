{ inputs, outputs, ... }:

{
  nixpkgs.overlays = [
    outputs.overlays.core-packages
    outputs.overlays.local-packages
    outputs.overlays.modifications
    outputs.overlays.old-stable-packages
    outputs.overlays.old-old-stable-packages
    outputs.overlays.unstable-packages

    inputs.nix-matlab.overlay
  ];
}
