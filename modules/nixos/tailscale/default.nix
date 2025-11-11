let
  login-server = "https://headscale.portuus.de";
in
{
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--login-server=${login-server}"
      "--ssh"
    ];
    extraDaemonFlags = [
      "--login-server=${login-server}"
    ];
  };
}
