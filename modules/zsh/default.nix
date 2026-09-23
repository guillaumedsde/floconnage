{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    initContent = builtins.readFile ./.zshrc;
  };
}
