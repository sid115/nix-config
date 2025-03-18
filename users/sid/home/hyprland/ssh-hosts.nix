{
  programs.ssh.matchBlocks = {
    arch = {
      host = "a arch";
      hostname = "192.168.122.120";
      port = 22;
      user = "sid";
    };
    debian = {
      host = "d debian";
      hostname = "192.168.122.208";
      port = 22;
      user = "sid";
    };
    jfk = {
      host = "j jfk";
      hostname = "cgn.ovh";
      port = 2299;
      user = "jfk";
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
    vde = {
      host = "v vde";
      hostname = "192.168.188.22";
      port = 22;
      user = "sid";
    };
  };
}
