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
        # enable = true;
        settings = {
          # file_types = [
          #   "Avante"
          # ];
        };
      };
    };
    extraConfigLua = ''
      _G.cppman_picker = function(opts)
        local pickers = require "telescope.pickers"
        local finders = require "telescope.finders"
        local conf = require("telescope.config").values
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"
        local previewers = require "telescope.previewers"

        opts = opts or {}
        pickers.new(opts, {
          prompt_title = "Cppman Search",
          finder = finders.new_oneshot_job({ "cppman", "-l" }, opts),
          sorter = conf.generic_sorter(opts),
          
          -- FIXED: The correct way to create a terminal previewer
          previewer = previewers.new_buffer_previewer({
            title = "Manual Page",
            define_preview = function(self, entry, status)
              return require("telescope.previewers.utils").job_maker(
                { "cppman", entry.value },
                self.state.bufnr,
                {
                  callback = function(bufnr, content)
                    if content then
                      vim.api.nvim_buf_set_option(bufnr, "filetype", "man")
                    end
                  end,
                }
              )
            end,
          }),

          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              
              if not selection then
                return
              end

              actions.close(prompt_bufnr)
              -- Open as a proper man page if possible, or terminal fallback
              vim.cmd("terminal cppman " .. selection.value)
              vim.cmd("startinsert")
            end)
            return true
          end,
        }):find()
      end
    '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>lua cppman_picker()<CR>";
        options = {
          desc = "Search C/C++ Docs (cppman)";
          silent = true;
        };
      }
    ];
  };
}
