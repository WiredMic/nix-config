{ pkgs, lib, config, inputs, ... }: {
  imports = [ ];

  options = { de.cosmic.enable = lib.mkEnableOption "enables cosmic config"; };

  config = lib.mkIf config.de.cosmic.enable {
    # services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic-greeter.enable = true;
  };
}
