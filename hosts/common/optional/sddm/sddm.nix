{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = { my.sddm.enable = lib.mkEnableOption "enables sddm config"; };

  config = lib.mkIf config.my.sddm.enable {
    environment.systemPackages = with pkgs; [
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };
}
