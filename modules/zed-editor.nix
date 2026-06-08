{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "rumdl"
    ];
    extraPackages = [
      pkgs.nil
      pkgs.nixd
      pkgs.rumdl # TODO: check if zed uses this rumdl
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
    };
  };
}
