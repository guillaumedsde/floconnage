{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  glmModel = name: {
    inherit name;
    max_tokens = 1000000;
    max_output_tokens = 128000;
    max_completion_tokens = 200000;
    supports_tools = true;
    supports_thinking = true;
    supports_images = false;
  };
in
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
      "golangci-lint"
    ];
    extraPackages = [
      pkgs.uv
      pkgs.nixfmt
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
        sidebar_side = "right";
        dock = "right";
        default_profile = "write";
        default_model = {
          provider = "Mistral OpenAI API";
          model = "zai-glm-5-3";
          enable_thinking = true;
        };
      };
      language_models = {
        mistral = {
          api_url = "https://api.eu.mistral.ai/v1";
          available_models = [
            (glmModel "zai-glm-5-2")
            (glmModel "zai-glm-5-3")
          ];
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
        bash-language-server.binary = {
          path = lib.getExe pkgs.bash-language-server;
          arguments = [ "start" ];
        };
        nil.binary.path = lib.getExe pkgs.nil;
        nixd.binary.path = lib.getExe pkgs.nixd;
        gopls.binary.path = lib.getExe pkgs.gopls;
        golangci-lint = {
          # https://github.com/nametake/golangci-lint-langserver#configuration
          binary.path = lib.getExe pkgs.golangci-lint-langserver;
          initialization_options.command = [
            "${lib.getExe pkgs.golangci-lint}"
            "run"
            "--output.json.path"
          ];
        };
        basedpyright.binary = {
          path = lib.getExe' pkgs.basedpyright "basedpyright-langserver";
          arguments = [ "--stdio" ];
        };
        ruff.binary = {
          path = lib.getExe pkgs.ruff;
          arguments = [ "server" ];
        };
        tofu-ls.binary = {
          path = lib.getExe pkgs.tofu-ls;
          arguments = [ "serve" ];
        };
        tflint.initialization_options.command = "${lib.getExe pkgs.tflint}";
        docker-language-server = {
          binary = {
            path = lib.getExe pkgs.docker-language-server;
            arguments = [
              "start"
              "--stdio"
            ];
          };
          initialization_options = {
            telemetry = "off";
          };
        };
        dockerfile-language-server.binary = {
          path = lib.getExe pkgs.dockerfile-language-server;
          arguments = [
            "start"
            "--stdio"
          ];
        };
        rumdl.binary = {
          path = lib.getExe pkgs.rumdl;
          arguments = [ "server" ];
        };
        ansible.binary = {
          path = lib.getExe pkgs.ansible-language-server;
          arguments = [
            "--stdio"
          ];
        };
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
        # NOTE: nil is not used but still installed to prevent zed from
        # trying to install it
        Nix.language_servers = [
          "nixd"
          "!nil"
        ];
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
