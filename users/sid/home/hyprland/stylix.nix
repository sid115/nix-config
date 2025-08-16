{ inputs, ... }:

{
  imports = [
    inputs.core.homeModules.stylix
  ];

  stylix = {
    enable = true;
    scheme = "moonfly";
    targets = {
      waybar'.enable = true;
      bemenu'.enable = true;
    };
  };
}
