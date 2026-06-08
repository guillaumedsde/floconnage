{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    extraPackages = [
        pkgs.nil
        pkgs.nixd
    ];
  };
}
