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
    # Ansible-core with tomlkit in the same site-packages so `import tomlkit`
    # works from inside ansible. Keep exactly one ansible derivation in the
    # profile: adding another one alongside it (e.g. pkgs.ansible, or a
    # machine-level python env) collides on bin/ansible and fails the
    # profile buildEnv with "conflicting subpath". ansible-core only —
    # install community collections at runtime with
    # `ansible-galaxy collection install`.
    (pkgs.python314.withPackages (ps: [
      ps.ansible-core
      ps.tomlkit
    ]))
    pkgs.ansible-lint
    pkgs.uv
    pkgs.nixfmt
  ];

  home.sessionVariables = {
    DIFFPROG = "zeditor --diff";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
