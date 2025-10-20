{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.monero;
  sops = config.sops;

  inherit (lib) mkDefault mkIf getExe;
in
{
  config = mkIf cfg.enable {
    services.monero = {
      environmentFile = sops.templates."monero/environment-file".path;
      mining.enable = false; # use XMRig + P2Pool
      rpc = {
        address = mkDefault "127.0.0.1";
        port = mkDefault 18081;
        user = mkDefault "monero";
        password = mkDefault "$MONERO_RPC_PASSWORD";
      };
      extraConfig = ''
        zmq-pub=tcp://127.0.0.1:18083
        out-peers=32
        in-peers=64
        prune-blockchain=1
        sync-pruned-blocks=1
        add-priority-node=p2pmd.xmrvsbeast.com:18080
        add-priority-node=nodes.hashvault.pro:18080
        enforce-dns-checkpointing=1
        enable-dns-blocklist=1
      '';
    };

    systemd.services.p2pool = {
      description = "P2Pool Monero Sidechain Node";
      after = [
        "monero.service"
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.p2pool ];

      serviceConfig = {
        User = "p2pool";
        Group = "p2pool";
        WorkingDirectory = "/var/lib/p2pool";
        ExecStart = "${getExe pkgs.p2pool} --host 127.0.0.1 --wallet ${cfg.mining.address}";
        Restart = "always";
        RestartSec = 10;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };

    users.users.p2pool = {
      isSystemUser = true;
      group = "p2pool";
      home = "/var/lib/p2pool";
      createHome = true;
    };
    users.groups.p2pool = { };

    services.xmrig = {
      enable = true;
      settings = {
        autosave = true;
        cpu = {
          enabled = true;
          huge-pages = true;
          hw-aes = null;
          asm = true;
          yield = true;
        };
        opencl.enabled = false;
        cuda.enabled = false;
        pools = [
          {
            url = "127.0.0.1:3333";
            user = "";
            pass = "";
          }
        ];
        api.enable = true;
      };
    };

    sops =
      let
        owner = "monero";
        group = "monero";
        mode = "0440";
      in
      {
        secrets."monero/rpc-password" = {
          inherit owner group mode;
        };
        templates."monero/environment-file" = {
          inherit owner group mode;
          content = ''
            MONERO_RPC_PASSWORD=${sops.placeholder."monero/rpc-password"}
          '';
        };
      };
  };
}
