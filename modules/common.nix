# Baseline configuration shared by every machine that consumes this flake.
# Consuming flakes import this as `inputs.common.homeManagerModules.common`.
#
# Composition rules with a machine's own home.nix:
#   - home.packages: list options concatenate, machine packages add up to these.
#   - home.sessionVariables: merges per key; to override a value on a machine,
#     use `lib.mkForce` (redefining it without mkForce is a conflict error).
{ pkgs, ... }:

{
  targets.genericLinux.enable = true;
  xdg.autostart.enable = true;

  # Packages installed on every machine that imports this module.
  home.packages = [
    pkgs.kubectl
    pkgs.jq
  ];

  home.sessionVariables = {
    DIFFPROG = "zeditor --diff";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
