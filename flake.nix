{
  description = "Common Home Manager modules shared across machines";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    {
      # Reusable modules exposed for consumption by other flakes.
      # The nixpkgs / nixpkgs-unstable / home-manager inputs stay declared so
      # consuming flakes can override them with `follows`.
      # Import individually: inputs.<name>.homeManagerModules.<name>
      homeManagerModules = {
        common = import ./modules/common.nix;
        zed-editor = import ./modules/zed-editor;
        zsh = import ./modules/zsh;
        fzf = import ./modules/fzf.nix;
        fonts = import ./modules/fonts.nix;
        gnome-terminal = import ./modules/gnome-terminal.nix;
        firefox = import ./modules/firefox.nix;
        keepassxc = import ./modules/keepassxc.nix;
        bat = import ./modules/bat.nix;
        git = import ./modules/git.nix;
      };
    };
}
