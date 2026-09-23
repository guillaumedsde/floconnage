# Fonts used across this setup: the gnome-terminal profile sets
# `font = "Fira Code 12"` and Zed uses it for the editor buffer.
{ pkgs, ... }: {
  home.packages = [
    pkgs.fira-code
  ];
}
