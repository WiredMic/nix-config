{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = {
    my.games.enable = lib.mkEnableOption "enables my game launchers";
  };

  config = lib.mkIf config.my.games.enable {

    environment.systemPackages = with pkgs; [ lutris protonup-qt mangohud ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers

      gamescopeSession = {
        enable = true;
        env = { }; # enviromental variables
        args =
          [ ]; # arguments https://github.com/ValveSoftware/gamescope?tab=readme-ov-file#options
      };
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
