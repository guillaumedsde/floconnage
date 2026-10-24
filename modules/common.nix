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
    #
    # Only the ansible* entry points are linked into the profile. Linking
    # the interpreter too would shadow /usr/bin/python3 (home-manager
    # prepends ~/.nix-profile/bin to PATH) and hijack scripts with a
    # `#!/usr/bin/env python3` shebang, e.g. pacman's virt-manager which
    # then dies on `import gi`.
    (
      let
        pythonEnv = pkgs.python314.withPackages (ps: [
          ps.ansible-core
          ps.tomlkit
        ]);
      in
      pkgs.runCommand "ansible-core-tomlkit" { } ''
        mkdir -p $out/bin
        for exe in ${pythonEnv}/bin/ansible ${pythonEnv}/bin/ansible-*; do
          ln -s -- "$exe" "$out/bin/$(basename "$exe")"
        done
      ''
    )
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
