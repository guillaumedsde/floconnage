{
  description = "Home Manager configuration of architect";

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
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      allModules = [
        ./modules/zed-editor.nix
        ./modules/zsh
        ./modules/fzf.nix
        ./modules/fonts.nix
        ./modules/gnome-terminal.nix
        ./modules/firefox.nix
        ./modules/keepassxc.nix
        ./modules/bat
      ];
    in
    {
      # Reusable modules exposed for consumption by other flakes.
      # Import individually: inputs.home-manager.homeManagerModules.<name>
      homeManagerModules = {
        zed-editor = import ./modules/zed-editor.nix;
        zsh = import ./modules/zsh;
        fzf = import ./modules/fzf.nix;
        fonts = import ./modules/fonts.nix;
        gnome-terminal = import ./modules/gnome-terminal.nix;
        firefox = import ./modules/firefox.nix;
        keepassxc = import ./modules/keepassxc.nix;
        bat = import ./modules/bat;
      };

      homeConfigurations."architect" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = allModules ++ [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit pkgs-unstable;
        };
      };
    };
}
