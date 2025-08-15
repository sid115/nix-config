{ pkgs, ... }:

{
  programs.ssh.matchBlocks = {
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
    pltl = {
      host = "pltl pltl-guac";
      hostname = "f07-ws-plt-132.f07-au.fh-koeln.de";
      port = 28677;
      user = "admin";
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
      sid = {
        host = "sid.ovh";
        user = "sid";
        port = 2299;
        mountPoint = "/home/sid/.config/nixos";
      };
    };
  };
  home.shellAliases.sm = "sftpman";
  home.packages = [ pkgs.sshfs ];
}
