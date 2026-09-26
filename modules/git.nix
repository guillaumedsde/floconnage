{ ... }: {
  programs.git = {
    enable = true;
    ignores = [
      ".zed/"
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };
}
