# Floconnage

Common Home Manager configuration shared across machines.

## Getting started

1. Install nix
2. [Install Home-manager][home-manager-install]
3. For non-NixOS Linux distributions:

   ```bash
   sudo $(which non-nixos-gpu-setup)
    ```

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
| `zed-editor`    | `modules/zed-editor.nix`|
| `zsh`           | `modules/zsh`            |
| `fzf`           | `modules/fzf.nix`        |
| `gnome-terminal`| `modules/gnome-terminal.nix` |
| `firefox`       | `modules/firefox.nix`    |
| `keepassxc`     | `modules/keepassxc.nix`  |

Machine-specific settings and overrides go in the consuming flake's
`home.nix`, which is evaluated after the imported modules so its values win.

[home-manager-install]: https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
