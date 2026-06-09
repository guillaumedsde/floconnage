{ ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Atom One Light";
    };
  };
}
