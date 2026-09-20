{ ... }: {
  programs.gnome-terminal = {
    enable = true;
    profile.default = {
      scrollbackLines = 20000;
      themeVariant = "system";
    };
  };
}
