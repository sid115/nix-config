{ config, inputs, ... }:

{
  imports = [ inputs.core.nixosModules.anything-llm-oci ];

  services.anything-llm-oci = {
    enable = true;
    environment = {
      LLM_PROVIDER = "openrouter";
      OPENROUTER_MODEL_PREF = "google/gemini-3-pro-preview";
    };
    environmentFile = config.sops.templates."anything-llm-oci/environment".path;
  };

  sops = {
    secrets."anything-llm-oci/openrouter-api-key" = { };

    # Generate with: nix-shell -p openssl --run "openssl rand -hex 32"
    secrets."anything-llm-oci/jwt-secret" = { };
    secrets."anything-llm-oci/sig-key" = { };
    secrets."anything-llm-oci/sig-salt" = { };

    templates."anything-llm-oci/environment".content = ''
      OPENROUTER_API_KEY=${config.sops.placeholder."anything-llm-oci/openrouter-api-key"}
      JWT_SECRET=${config.sops.placeholder."anything-llm-oci/jwt-secret"}
      SIG_KEY=${config.sops.placeholder."anything-llm-oci/sig-key"}
      SIG_SALT=${config.sops.placeholder."anything-llm-oci/sig-salt"}
    '';
  };
}
