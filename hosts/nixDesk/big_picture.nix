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

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    # CreateSwapchainHKR: Creating swapchain for non-Gamescope swapchain.
    # Hooking has failed somewhere!
    # You may have a bad Vulkan layer interfering.

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
    services.udev.extraRules = '''';

    programs.gamemode.enable = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

    # Load PlayStation controller kernel module
    boot.kernelModules = [ "hid_playstation" ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # The newer versions of bluetooth does not work with dualsence
      package = lib.mkForce pkgs.bluez;
      settings = {
        General = {
          ControllerMode = lib.mkForce "bredr";
          FastConnectable = "true";
          Experimental = "true";
          # Enable Steam Controller support
          Class = "0x000100";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };

    # Ensure bluetooth is accessible in gamescope session
    services.blueman.enable = true;

  };
}
