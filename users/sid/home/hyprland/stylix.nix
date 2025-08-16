{ inputs, ... }:

{
  imports = [
    inputs.core.homeModules.stylix
  ];

  stylix = {
    enable = true;
    scheme = "oxocarbon";
    targets = {
      waybar'.enable = true;
      bemenu'.enable = true;
    };
  };
}
