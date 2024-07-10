{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = { my.rust.enable = lib.mkEnableOption "enables rust"; };

  config = lib.mkIf config.my.rust.enable {

    home.packages = with pkgs; [ rustup ];

    home.sessionPath = [
      "$CARGO_HOME/bin"

    ];

    home.sessionVariables = {
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };
    # rustup default stable
    # https://ayats.org/blog/nix-rustup/
  };
}
