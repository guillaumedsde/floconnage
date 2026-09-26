# Floconnage

Common Home Manager modules shared across machines. This flake is a pure
module library: it only exposes `homeManagerModules` and does not define any
`homeConfigurations` of its own.

## Reusing modules from another flake

This flake exposes individual Home Manager modules via the
`homeManagerModules` flake output, so other machines can import only the
modules they need and override any settings.

Add this flake as an input (replace the URL with your fork if needed):

```nix
inputs.common.url = "github:guillaumedsde/floconnage";
```

Then select the modules you want:

```nix
modules = [
  common.homeManagerModules.common  # shared baseline: packages, session variables, ...
  common.homeManagerModules.zed-editor
  common.homeManagerModules.zsh
  common.homeManagerModules.fzf
  common.homeManagerModules.gnome-terminal
  common.homeManagerModules.firefox
  common.homeManagerModules.keepassxc
  ./home.nix  # machine-specific settings and overrides
];
```

Available modules under `homeManagerModules`:

| Key             | Source                  |
|-----------------|-------------------------|
| `common`        | `modules/common.nix`    |
| `zed-editor`    | `modules/zed-editor.nix`|
| `zsh`           | `modules/zsh`            |
| `fzf`           | `modules/fzf.nix`        |
| `gnome-terminal`| `modules/gnome-terminal.nix` |
| `firefox`       | `modules/firefox.nix`    |
| `keepassxc`     | `modules/keepassxc.nix`  |
| `fonts`         | `modules/fonts.nix`     |
| `bat`           | `modules/bat`            |

The `common` module holds configuration shared by every consuming machine:
packages, session variables and other baseline settings. It composes with the
machine's own `home.nix` as follows:

- `home.packages` lists are concatenated: machine packages add up to the
  common ones.
- `home.sessionVariables` merges per key; to override a value, use
  `lib.mkForce` in the machine's `home.nix` (redefining a key without
  `mkForce` is a conflict error).

Machine-specific settings and overrides go in the consuming flake's
`home.nix`.
