{ inputs, config, ... }:

{
  imports = [
    inputs.core.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    plugins = {
      # avante = {
      #   enable = true;
      #   autoLoad = true;
      #   settings = {
      #     selector.provider = "telescope";
      #     auto_suggestions_provider = null;
      #     provider = "openrouter";
      #     providers = {
      #       openrouter = {
      #         __inherited_from = "openai";
      #         endpoint = "https://openrouter.ai/api/v1";
      #         api_key_name = "cmd:cat ${config.sops.secrets.openrouter-api-key.path}";
      #         model = "google/gemini-2.5-flash-preview-05-20";
      #       };
      #     };
      #   };
      # };
      render-markdown = {
        enable = true;
        settings = {
          file_types = [
            "Avante"
          ];
        };
      };
      which-key.enable = true;
      # cmp-nvim-ultisnips.enable = true;
    };
  };
}
