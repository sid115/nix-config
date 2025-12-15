{ pkgs, ... }:

{
  programs.ssh.matchBlocks = {
    edge = {
      host = "e edge";
      hostname = "49.12.227.10";
      port = 2299;
      user = "sid";
    };
    uvm = {
      host = "u uvm";
      hostname = "localhost";
      port = 2222;
      user = "root";
      checkHostIP = false;
    };
    portuus = {
      host = "p portuus *.portuus.de";
      hostname = "portuus.de";
      port = 2299;
      user = "sid";
    };
    sid = {
      host = "s sid *.sid.ovh";
      hostname = "sid.ovh";
      port = 2299;
      user = "sid";
    };
    vde = {
      host = "v vde vde.lan";
      hostname = "192.168.1.144";
      port = 2299;
      user = "sid";
    };
  };

  # setup: sudo mkdir -p /mnt/sshfs && sudo chown sid:sid /mnt/sshfs
  programs.sftpman = {
    enable = true;
    # gpg --export-ssh-key <auth key id> > ~/.ssh/id_rsa.pub
    defaultSshKey = "/home/sid/.ssh/id_rsa.pub";
    mounts = {
      portuus = {
        host = "portuus.de";
        user = "sid";
        port = 2299;
        mountPoint = "/home/sid/.config/nixos";
      };
    };
  };
  home.shellAliases.sm = "sftpman";
  home.packages = [ pkgs.sshfs ];
}
