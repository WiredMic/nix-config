{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = {
    my.emulation.enable = lib.mkEnableOption "enables my emulatores config";
  };

  config = lib.mkIf config.my.sddm.enable {
    environment.systemPackages = with pkgs; [ ];

    # https://github.com/gmodena/nix-flatpak
    services.flatpak.enable = true;

    # services.flatpak.remotes = lib.mkOptionDefault [{
    #   name = "flathub-beta";
    #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    # }];

    services.flatpak.packages = [
      {
        appId = "net.retrodeck.retrodeck";
        origin = "flathub";
      }
      {
        appId = "org.yuzu_emu.yuzu";
        origin = "flathub";
      }

    ];
  };

}
