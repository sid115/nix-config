{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.open-webui-oci ];

  services.open-webui-oci = {
    enable = true;
    port = 8081;
    environment = {
      AUDIO_STT_ENGINE = "openai";
      AUDIO_TTS_ENGINE = "openai";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8081 ];

  sops = {
    secrets."open-webui-oci/stt-api-key" = { };
    secrets."open-webui-oci/tts-api-key" = { };
    templates."open-webui-oci/environment".content = ''
      AUDIO_STT_OPENAI_API_KEY=${config.sops.placeholder."open-webui-oci/stt-api-key"}
      AUDIO_TTS_OPENAI_API_KEY=${config.sops.placeholder."open-webui-oci/tts-api-key"}
    '';
  };
}
