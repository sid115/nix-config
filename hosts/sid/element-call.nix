{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = "sid.ovh";
  baseUrl = "https://${domain}";

  # nix-shell -p livekit --run "livekit-server generate-keys | tail -1 | awk '{print $3}'"
  keyFile = config.sops.templates."livekit/key".path;

  clientConfig = {
    "m.homeserver".base_url = baseUrl;
    "m.identity_server".base_url = "https://vector.im";
    "org.matrix.msc3575.proxy".url = baseUrl;
    "org.matrix.msc4143.rtc_foci" = [
      {
        type = "livekit";
        livekit_service_url = baseUrl + "/livekit/jwt";
      }
    ];
  };

  callConfig = {
    default_server_config = {
      "m.homeserver" = {
        base_url = baseUrl;
        server_name = domain;
      };
    };
    livekit = {
      livekit_service_url = config.services.lk-jwt-service.livekitUrl;
    };
    features = {
      feature_use_device_session_member_events = true;
    };
    ssla = "https://static.element.io/legal/element-software-and-services-license-agreement-uk-1.pdf";
    matrix_rtc_session = {
      wait_for_key_rotation_ms = 3000;
      membership_event_expiry_ms = 180000000;
      delayed_leave_event_delay_ms = 18000;
      delayed_leave_event_restart_ms = 4000;
      network_error_retry_ms = 100;
    };
  };

  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';

in
{
  services.livekit = {
    enable = true;
    openFirewall = true;
    settings.room.auto_create = false;
    inherit keyFile;
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://${domain}/livekit/sfu"; # can be on the same virtualHost as synapse
    inherit keyFile;
  };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = domain;

  services.nginx.virtualHosts = {
    "${domain}".locations = {
      "^~ /livekit/jwt/" = {
        priority = 400;
        proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
      };
      "^~ /livekit/sfu/" = {
        extraConfig = ''
          proxy_send_timeout 120;
          proxy_read_timeout 120;
          proxy_buffering off;

          proxy_set_header Accept-Encoding gzip;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
        priority = 400;
        proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
        proxyWebsockets = true;
      };
      "= /.well-known/matrix/client".extraConfig = lib.mkForce (mkWellKnown clientConfig);
    };
    # FIXME: keeps loading
    "call.${domain}" = {
      root = pkgs.element-call;
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        extraConfig = "try_files $uri /$uri /index.html;";
      };
      locations."/public/config.json" = {
        extraConfig = ''
          add_header Cache-Control "no-cache, must-revalidate";
          default_type application/json;
          return 200 '${builtins.toJSON callConfig}';
        '';
      };
    };
  };

  sops.secrets."livekit/key" = { };
  sops.templates."livekit/key".content = ''
    API Secret:  ${config.sops.placeholder."livekit/key"}
  '';
}
