let
  user = "sid";
in
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      data-root = "/home/${user}/.local/share/docker";
    };
  };

  users.extraGroups.docker.members = [ user ];
}
