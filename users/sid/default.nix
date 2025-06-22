{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.normalUsers
  ];

  normalUsers = {
    sid = {
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ./pubkeys/gpg.pub
      ];
    };
  };
}
