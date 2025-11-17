let
  login-server = "https://hs.sid.ovh";
in
{
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--login-server=${login-server}"
      "--ssh"
    ];
  };
}
