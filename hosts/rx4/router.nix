{
  networking.interfaces."enp2s0" = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.0.0.1";
        prefixLength = 24;
      }
    ];
  };

  networking.firewall.extraCommands = ''
    iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
    iptables -A INPUT -i enp2s0 -j ACCEPT
  '';

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [
    53
    67
  ];

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [
          "enp2s0"
        ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      rebind-timer = 2000;
      renew-timer = 1000;
      subnet4 = [
        {
          id = 1;
          pools = [
            {
              pool = "10.0.0.2 - 10.0.0.255";
            }
          ];
          subnet = "10.0.0.1/24";
        }
      ];
      valid-lifetime = 4000;
      option-data = [
        {
          name = "routers";
          data = "10.0.0.1";
        }
      ];
    };
  };
}
