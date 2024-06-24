{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = {
    my.games.enable = lib.mkEnableOption "enables my game launchers";
  };

  config = lib.mkIf config.my.games.enable {

    environment.systemPackages = with pkgs; [ lutris protonup-qt mangohud ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;

    # https://github.com/gmodena/nix-flatpak
    services.flatpak.enable = true;

    # services.flatpak.remotes = lib.mkOptionDefault [{
    #   name = "flathub-beta";
    #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    # }];

    services.flatpak.packages = [
      # {
      #   appId = "com.valvesoftware.Steam";
      #   origin = "flathub";
      # }
      {
        appId = "com.heroicgameslauncher.hgl";
        origin = "flathub";
      }
      {
        appId = "com.github.Matoking.protontricks";
        origin = "flathub";
      }
      {
        appId = "net.davidotek.pupgui2";
        origin = "flathub";
      }
      # { appId = "net.lutris.Lutris"; origin = "flathub"; }
      # { appId = "net.davidotek.pupgui2"; origin = "flathub"; }
    ];

    # add steam-devices
    hardware.steam-hardware.enable = true;
    # services.udev.packages = [ (pkgs.callPackage ./steam-devices.nix { }) ];
  };
}
