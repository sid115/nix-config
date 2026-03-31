{
  networking.hostName = "pc";
  networking.interfaces.enp6s0.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };
}
