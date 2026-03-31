{
  inputs,
  outputs,
  config,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh

    outputs.nixosModules.forgejo-runner
  ];

  services = {
    openssh.enable = true;
  };

  services.forgejo-runner = {
    enable = true;
    url = "https://git.sid.ovh";
    tokenFile = config.sops.templates."forgejo-runner/token".path;
    label = "runner";
  };

  sops = {
    secrets."forgejo-runner/token" = { };
    templates."forgejo-runner/token".content = ''
      TOKEN=${config.sops.placeholder."forgejo-runner/token"}
    '';
  };
}
