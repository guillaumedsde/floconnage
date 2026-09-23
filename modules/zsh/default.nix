{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    # Entries kept in memory = what fzf ctrl-r searches. history.save
    # (SAVEHIST) stays at the 10000 default, so ~/.zsh_history still
    # accumulates more lines on disk than are loaded.
    history.size = 2500;
    initContent = builtins.readFile ./.zshrc;
  };
}
