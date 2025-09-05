{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.wg-client ];

  networking.wg-client = {
    enable = true;
    interfaces = {
      wg0 = {
        clientAddress = "10.0.0.2";
        peer = {
          publicIP = "91.99.172.127";
          publicKey = "hRrnXl1heROHfpXkHOmjITUpG/ht3omVsWurLcChIS4=";
        };
      };
    };
  };
}
