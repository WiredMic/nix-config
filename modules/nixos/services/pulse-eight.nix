{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.services.pulse-eight;

  pulse8-cec-autoattach = pkgs.writeTextFile {
    name = "pulse8-cec-autoattach";
    destination = "/etc/udev/rules.d/pulse8-cec-autoattach.rules";
    text = ''
      SUBSYSTEM=="tty", ACTION=="add", ATTRS{manufacturer}=="Pulse-Eight", ATTRS{product}=="${cfg.usbProductString}", TAG+="systemd", ENV{SYSTEMD_WANTS}="pulse8-cec-attach@$devnode.service"
      SUBSYSTEM=="usb", ATTR{manufacturer}=="Pulse-Eight", ATTR{product}=="${cfg.usbProductString}", ATTR{power/persist}="0"
      SUBSYSTEM=="usb", ACTION=="change", ATTR{manufacturer}=="Pulse-Eight", ATTR{product}=="${cfg.usbProductString}", ENV{DEVNUM}=="000", ATTR{bConfigurationValue}=="1", ATTR{bConfigurationValue}="1"
    '';
  };

  cec-configure-autostart = pkgs.writeTextFile {
    name = "cec-configure-autostart";
    destination = "/etc/udev/rules.d/cec-configure-autostart.rules";
    text = ''
      SUBSYSTEM=="cec", KERNEL=="cec0", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="cec0-configure.service"
    '';
  };

  cec-permissions = pkgs.writeTextFile {
    name = "cec-permissions";
    destination = "/etc/udev/rules.d/cec-permissions.rules";
    text = ''
      KERNEL=="cec[0-9]*", GROUP="cec", MODE="0664"
    '';
  };

  deviceClassFlag =
    {
      playback = "--playback";
      tuner = "--tuner";
      record = "--record";
    }
    .${cfg.deviceClass};

in
{
  options.services.pulse-eight = {
    enable = mkEnableOption "the PulseEight USB-CEC adapter";

    usbProductString = mkOption {
      type = types.str;
      default = "CEC Adapter";
      description = "Value of udev ATTRS{product}. Confirmed via lsusb -v for your unit.";
    };

    osdName = mkOption {
      type = types.str;
      default = "NixOS-PC";
      description = "Name advertised to the TV/AVR menus. Max 14 ASCII chars.";
    };

    deviceClass = mkOption {
      type = types.enum [
        "playback"
        "tuner"
        "record"
      ];
      default = "playback";
      description = "CEC device role to register as.";
    };

    hdmiConnector = mkOption {
      type = types.str;
      description = "DRM connector name physically cabled through the CEC adapter, e.g. card1-HDMI-A-1. Find with: ls /sys/class/drm";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Users to add to the `cec` group for /dev/cec* access.";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelPatches = [
      {
        name = "pulse8-cec";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          MEDIA_SUPPORT = yes;
          MEDIA_CEC_SUPPORT = yes;
          USB_PULSE8_CEC = module;
        };
      }
    ];

    environment.systemPackages = with pkgs; [
      v4l-utils
      linuxConsoleTools
    ];

    systemd.services."pulse8-cec-attach@" = {
      description = "Configure USB Pulse-Eight serial device at %I";
      unitConfig.ConditionPathExists = "%I";
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.linuxConsoleTools}/bin/inputattach --daemon --pulse8-cec %I";
        RemainAfterExit = true;
      };
    };

    systemd.services."cec0-configure" = {
      description = "Configure CEC adapter cec0 (logical address, OSD name)";
      bindsTo = [ "dev-cec0.device" ];
      after = [ "dev-cec0.device" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.v4l-utils}/bin/cec-ctl --device=0 --osd-name=${cfg.osdName} ${deviceClassFlag} --phys-addr-from-edid-poll=/sys/class/drm/${cfg.hdmiConnector}/edid";
        Restart = "on-failure";
      };
    };

    users.groups.cec = { };
    users.users = lib.genAttrs cfg.users (_: {
      extraGroups = [ "cec" ];
    });

    services.udev.packages = [
      pulse8-cec-autoattach
      cec-configure-autostart
      cec-permissions
    ];
  };
}
