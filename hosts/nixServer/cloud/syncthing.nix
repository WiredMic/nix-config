{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    server.syncthing.enable = lib.mkEnableOption "enables syncthing to sync between my devices";
  };

  config = lib.mkIf config.server.syncthing.enable {
    # Syncthing is avaliable at port 8384
    services.syncthing = {
      enable = true;
      package = pkgs.syncthing;
      systemService = true;
      # guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true; # TCP/UDP 22000 for transfers and UDP 21027 for discovery
      # nix-shell -p syncthing --run "syncthing generate --config myconfig/"
      # key = "${/home/rasmus/secrets/syncthing/key.pem}";
      # cert = "${/home/rasmus/secrets/syncthing/cert.pem}";
      settings = {
        devices = {
          "nixLap" = {
            id = "2E5T57U-FXGMXE6-7LI6I2A-3NPHV32-C6YSFHD-A3CVZRW-KZLUBJR-F72L7AD";
          };
          "nixDesk" = {
            id = "KH4RAAK-57W3V5V-363IDVX-Q2TGYNS-YEOJHTT-IZ7BBKK-TSONZTM-ERJ2AAP";
          };
          "jacob_server" = {
            id = "IM7UAGB-C27YKYK-MO5GA3P-5MSL56Z-2P5MAB2-6FE4L3A-2PLTHJL-NKRTMQQ";
          };
          "jacob_laptop" = {
            id = "FAXDSBM-JAW4A2J-5XZHRRU-FES6EQ4-QYZLXEO-PENKEZ4-V3T2EZ5-7MOZEQA";
          };
          "jonas_laptop_linux" = {
            id = "FBZ3W52-TQZPS2G-5Y77PO6-BJLJ5TT-RGKA6IR-KBK7EFF-3PVV4AT-ON5ZAQL";
          };
          "jonas_laptop_windows" = {
            id = "A35QQGT-PEQV4CJ-UP2BR7N-XAKE65U-QEGHER5-YNHZAGF-64J6DFQ-FL673QO";
          };
          "lasse_laptop_windows" = {
            id = "72WYRQK-A7JECU4-XZUX6SJ-FTHVHFU-KLBVP7V-TAKTU73-OFXAUR2-DDACEQ5";
          };
          "magnus_laptop_windows" = {
            id = "D4A2GP6-EAZXUKI-3HYSJFZ-D2PB7AQ-YERJWHQ-GJOBPGT-44ZMV5C-YCDMLAN";
          };
          "rasmus_phone" = {
            id = "CP6EXAO-7ZAW2JJ-ZNOJ2EI-Y4BSGUC-U5ZIZF4-O5XX5PA-GCCHG2T-YHADQA4";
          };
        };
        folders = {
          "Org" = {
            path = "/mnt/ZPOOL0/share/Syncthing/Rasmus/Org"; # Which folder to add to Syncthing
            devices = [
              "nixLap"
              "nixDesk"
            ];
            id = "jsqci-fgvyv";
          };
          "Uni" = {
            path = "/mnt/ZPOOL0/share/Syncthing/Rasmus/Uni"; # Which folder to add to Syncthing
            devices = [
              "nixLap"
              "nixDesk"
            ];
            id = "nwqig-zp2gw";
          };
          "project-3-shared" = {
            path = "/mnt/ZPOOL0/share/Syncthing/Rasmus/project-3-shared"; # Which folder to add to Syncthing
            devices = [
              "nixLap"
              "nixDesk"
              "jacob_laptop"
              "jacob_server"
              "jonas_laptop_linux"
              "jonas_laptop_windows"
              "magnus_laptop_windows"
            ]; # Which devices to share the folder with
            id = "project-3-shared";
          };
          "project-4-shared" = {
            path = "/mnt/ZPOOL0/share/Syncthing/Rasmus/project-4-shared"; # Which folder to add to Syncthing
            devices = [
              "nixLap"
              "nixDesk"
              "jacob_laptop"
              "jacob_server"
              "jonas_laptop_linux"
              "jonas_laptop_windows"
              "magnus_laptop_windows"
              "lasse_laptop_windows"
            ];
            id = "ertml-eytca";
          };
          "rasmus_phone_dcim" = {
            path = "/mnt/ZPOOL0/share/Media/Photos/Rasmus/DCIM";
            devices = [ "rasmus_phone" ];
            id = "rasmus_phone_dcim";
          };
          # "Example" = {
          #   path = "/home/myusername/Example";
          #   devices = [ "device1" ];
          #   ignorePerms =
          #     false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          # };
        };
      };
    };
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall.allowedTCPPorts = [
      8384
      22000
    ];
    networking.firewall.allowedUDPPorts = [
      8384
      22000
      21027
    ];
    # environment.systemPackages = [ pkgs.syncthing ];
  };
}
