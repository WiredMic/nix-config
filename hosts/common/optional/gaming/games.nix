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
    my.games.enable = 
      lib.mkEnableOption "enables my game launchers";
  };

  config = lib.mkIf config.my.games.enable {

    environment.systemPackages = with pkgs; [
      lutris
    ];

    # https://github.com/gmodena/nix-flatpak
    services.flatpak.enable = true;

    # services.flatpak.remotes = lib.mkOptionDefault [{
    #   name = "flathub-beta";
    #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    # }];

    services.flatpak.packages = [
      { appId = "com.valvesoftware.Steam"; origin = "flathub";  }
      # { appId = "net.lutris.Lutris"; origin = "flathub"; }
      # { appId = "net.davidotek.pupgui2"; origin = "flathub"; }
    ];

    # add steam-devices
    services.udev.packages = [
      (pkgs.callPackage ./steam-devices.nix { })
    ];
  };
}
