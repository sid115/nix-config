{
  programs.ssh.matchBlocks = {
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
}
