{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    extensions = [
      "nix"
      "opentofu"
      "tflint"
      "rumdl"
      "ansible"
      "dockerfile"
      "gitlab-ci-ls"
    ];
    extraPackages = [
      pkgs.uv
    ];
    userSettings = {
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      edit_predictions = {
        provider = "none";
        allow_data_collection = "no";
      };
      title_bar.show_sign_in = false;
      collaboration_panel.button = false;
      preview_tabs.enabled = false;
      git_panel.dock = "left";
      project_panel.dock = "left";
      base_keymap = "VSCode";
      terminal.max_scroll_history_lines = 25000;
      # TODO
      # buffer_font_family = "Fira Code";
      theme = "Ayu Light";
      agent = {
        dock = "right";
        default_profile = "write";
        default_model = {
          provider = "Mistral OpenAI API";
          model = "zai-glm-5-2";
          enable_thinking = true;
        };
      };
      language_models = {
        openai_compatible = {
          "Mistral OpenAI API" = {
            api_url = "https://api.mistral.ai/v1";
            available_models = [
              {
                name = "zai-glm-5-2";
                max_tokens = 1000000;
                max_output_tokens = 128000;
                max_completion_tokens = 200000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                  interleaved_reasoning = false;
                };
              }
            ];
          };
        };
        ollama = { };
      };
      context_servers = {
        "OpenTofu MCP" = {
          enabled = true;
          url = "https://mcp.opentofu.org/mcp";
        };
        "Talos Linux MCP" = {
          enabled = true;
          url = "https://docs.siderolabs.com/mcp";
        };
        "JSON Schema Store MCP" = {
          enabled = true;
          url = "https://mcp.schemastore.org/";
        };
      };
      granted_extension_capabilities = [ ];
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
      lsp = {
        bash-language-server.binary.path = lib.getExe pkgs.bash-language-server;
        nil.binary.path = lib.getExe pkgs.nil;
        nixd.binary.path = lib.getExe pkgs.nixd;
        gitlab-ci.binary.path = lib.getExe pkgs.gitlab-ci-ls;
        gopls.binary.path = lib.getExe pkgs.gopls;
        basedpyright.binary.path = lib.getExe' pkgs.basedpyright "basedpyright-langserver";
        ruff.binary.path = lib.getExe pkgs.ruff;
        tofu-ls.binary.path = lib.getExe pkgs.tofu-ls;
        tflint.initialization_options.command = [
          lib.getExe pkgs.tflint
          "--langserver"
        ];
        docker-language-server = {
          binary.path = lib.getExe pkgs.docker-language-server;
          initialization_options = {
            telemetry = "off";
          };
        };
        dockerfile-language-server.binary.path = lib.getExe pkgs.dockerfile-language-server;
        rumdl.binary.path = lib.getExe pkgs.rumdl;
        ansible.binary.path = lib.getExe pkgs.ansible-language-server;
        ansible.settings = {
          ansible.path = lib.getExe' pkgs.ansible "ansible";
          validation.lint.path = lib.getExe pkgs.ansible-lint;
        };
        yaml-language-server = {
          binary = {
            path = lib.getExe pkgs.yaml-schema-router;
            arguments = [
              "--lsp-path"
              "${lib.getExe pkgs.yaml-language-server}"
            ];
          };
        };
      };
      languages = {
        "Shell Script".formatter.external = {
          command = lib.getExe pkgs.shfmt;
          arguments = [
            "--filename"
            "{buffer_path}"
            "--indent"
            "2"
          ];
        };
      };
      file_types = {
        "Ansible" = [
          "**.ansible.yml"
          "**.ansible.yaml"
          "**/defaults/*.yml"
          "**/defaults/*.yaml"
          "**/meta/*.yml"
          "**/meta/*.yaml"
          "**/tasks/*.yml"

          "**/handlers/*.yml"
          "**/handlers/*.yaml"
          "**/group_vars/*.yml"
          "**/group_vars/*.yaml"
          "**/playbooks/*.yaml"
          "**/playbooks/*.yml"
          "**playbook*.yaml"
          "**playbook*.yml"
        ];
      };
    };
  };
}
