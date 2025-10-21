{ config, ... }:

{
  programs.opencode = {
    enable = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      provider = {
        openrouter = {
          name = "OpenRouter";
          api_key = "{file:${config.sops.secrets.openrouter-api-key.path}}";
          models = {
            "google/gemini-2.5-flash" = {
              name = "Gemini 2.5 Flash";
            };
            "qwen/qwen3-coder" = {
              name = "Qwen3 Coder";
            };
          };
        };
      };
      model = "openrouter/qwen/qwen3-coder";
      autoshare = false;
      autoupdate = false;
    };
  };
}
