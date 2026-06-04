{
  lib,
  config,
  pkgs,
  pkgs-bluez-old,
  ...
}:
{
  imports = [ ];

  config = {

    # https://wiki.nixos.org/wiki/Steam#Tips_and_tricks

    environment.systemPackages = with pkgs; [
      # gamescope-wsi # HDR won't work without this
      # opengamepadui
      libcec
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      gamescopeSession = {
        enable = true;
        env = {
          # Set HDMI as default audio output for gamescope session
          PULSE_SINK = "alsa_output.pci-0000_08_00.1.hdmi-stereo-extra2";
          # Alternative variable that some apps use
          PIPEWIRE_NODE = "alsa_output.pci-0000_08_00.1.hdmi-stereo-extra2";

          # ENABLE_GAMESCOPE_WSI = "1";
          # DISABLE_VK_LAYER_VALVE_steam_overlay_1 = "1";
        };
        args = [
          "--xwayland-count 2"
          # "--expose-wayland"

          "-e" # Enable steam integration
          "--steam"

          "--prefer-output HDMI-A-1"
          # "--force-grab-cursor"
        ]; # arguments https://github.com/ValveSoftware/gamescope?tab=readme-ov-file#options
      };
    };

    # HDMI cec
    # https://wiki.archlinux.org/title/HDMI-CEC
    # SUBSYSTEM=="tty" ACTION=="add" ATTRS{manufacturer}=="Pulse-Eight" ATTRS{product}=="CEC Adapter" TAG+="systemd" ENV{SYSTEMD_WANTS}="pulse8-cec-attach@$devnode.service"
    # Udev rules for Pulse-Eight adapter

    programs.gamemode.enable = true;

    # Load PlayStation controller kernel module
    boot.kernelModules = [
      "hid-sony"
      "hid_playstation"
    ];

    hardware.firmware = [ pkgs.linux-firmware ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
      settings = {
        General = {
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true";
        };
        Policy = {
          AutoEnable = "true";
          ReconnectAttempts = 7;
          ReconnectIntervals = "1,2,4,8,16,32,64";
        };
      };
    };
  };
}
