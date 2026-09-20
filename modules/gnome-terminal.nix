{ ... }: {
  programs.gnome-terminal = {
    enable = true;
    themeVariant = "system";
    profile."dd17b21f-e2ce-4efb-9e9e-783a5527bacf" = {
      visibleName = "default";
      default = true;
      scrollbackLines = 20000;
    };
  };
}
