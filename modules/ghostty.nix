{ ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    auto-update = "off";
    settings = {
      theme = "Atom One Light";
    };
  };
}
