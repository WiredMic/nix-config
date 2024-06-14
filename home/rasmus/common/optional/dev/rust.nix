{ 
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
  ];

  options = {
    my.rust.enable =
      lib.mkEnableOption "enables rust";
  };

  config = lib.mkIf config.my.rust.enable {

    home.packages = with pkgs; [
      rustup
    ];

    # rustup default stable
    # https://ayats.org/blog/nix-rustup/
  };
}
