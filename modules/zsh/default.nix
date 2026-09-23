{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    # Entries kept in memory = what fzf ctrl-r searches. history.save
    # (SAVEHIST) stays at the 10000 default, so ~/.zsh_history still
    # accumulates more lines on disk than are loaded.
    history.size = 2500;
    # Skip re-scanning fpath when a completion dump exists (nix fpath is
    # immutable store paths, so the dump stays valid). This skips the fpath
    # scan and compaudit on every startup; the 841 compdef registrations
    # from the dump still run. Regenerate manually after adding a package
    # with completions:  rm ~/.zcompdump
    completionInit = ''
      autoload -Uz compinit
      if [[ -s ''${ZDOTDIR:-$HOME}/.zcompdump ]]; then
        compinit -C
      else
        compinit
      fi
    '';
    initContent = builtins.readFile ./.zshrc;
  };
}
