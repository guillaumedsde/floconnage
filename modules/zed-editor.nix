{ pkgs, lib, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "opentofu"
      "rumdl"
      "ansible"
      "dockerfile"
      "gitlab-ci-ls"
    ];
    userSettings = {
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      disable_ai = true;
      title_bar.show_sign_in = false;
      collaboration_panel.button = false;
      outline_panel.button = false;
      preview_tabs.enabled = false;
      git_panel.dock = "left";
      project_panel.dock = "left";
      base_keymap = "VSCode";
      # TODO
      # buffer_font_family = "Fira Code";
      theme = "Ayu Light";
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
        tofu-ls = {
          binary = {
            path = lib.getExe pkgs.tofu-ls;
            arguments = [ "serve" ];
          };
        };
        dockerfile-language-server = {
          binary = {
            path = lib.getExe pkgs.dockerfile-language-server;
            arguments = [ "--stdio" ];
          };
        };
        rumdl.binary = {
          path = lib.getExe pkgs.rumdl;
          arguments = [ "server" ];
        };
        ansible = {
          binary = {
            path = lib.getExe pkgs.ansible-language-server;
            arguments = [ "--stdio" ];
          };
          settings = {
            ansible.path = lib.getExe' pkgs.ansible "ansible";
            validation.lint.path = lib.getExe pkgs.ansible-lint;
          };
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
