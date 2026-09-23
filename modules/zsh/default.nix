{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    history.save = 20000;
    # Skip re-scanning fpath when a completion dump exists (nix fpath is
    # immutable store paths, so the dump stays valid). Sourcing the dump
    # registers completions via cheap _comps assignments — no fpath scan,
    # no compaudit, no compdef calls. Regenerate manually after adding a
    # package with completions:  rm ~/.zcompdump
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
