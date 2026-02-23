{
  inputs,
  outputs,
  config,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.windows-oci

    outputs.nixosModules.forgejo-runner
  ];

  services.openssh.enable = true;

  # FIXME:
  # connect in weechat:
  # /server add local localhost/6667
  # /set irc.server.local.password "abc"
  # /set irc.server.local.tls off
  # Access denied: Bad password?
  services.ngircd = {
    enable = true;
    config = ''
      [Global]
      Name = irc.local
      Info = Minimal ngIRCd Server
      Password = yourmom69
    '';
  };

  services.windows-oci = {
    # enable = true;
    sharedVolume = "/home/sid/pub";
  };
  time.hardwareClockInLocalTime = true; # Windows compatibility

  services.forgejo-runner = {
    # enable = true;
    url = "https://git.sid.ovh";
    # tokenFile = config.sops.templates."forgejo-runner/token".path;
    label = "runner";
  };
  # sops = {
  #   secrets."forgejo-runner/token" = { };
  #   templates."forgejo-runner/token".content = ''
  #     TOKEN=${config.sops.placeholder."forgejo-runner/token"}
  #   '';
  # };
}
