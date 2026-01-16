{
  config,
  lib,
  pkgs,
  ...
}:

let

  pulse8-cec-autoattach = (
    pkgs.writeTextFile {
      name = "pulse8-cec-autoattach";
      destination = "/etc/udev/rules.d/pulse8-cec-autoattach.rules";
      text = ''
        # Rule to automatically configure the PulseEight CEC adapter when connected
        SUBSYSTEM=="tty", ACTION=="add", ATTRS{manufacturer=="Pulse-Eight", ATTRS{product}=="USB-CEC Adapter", TAG+="systemd", ENV{SYSTEMD_WANTS}="pulse8-cec-attach@$devnode.service"

        # Force device reconfiguration after suspend/resume to trigger tty recreation
        SUBSYSTEM=="usb", ACTION=="change", ATTR{manufacturer}=="Pulse-Eight", ATTR{product}=="USB-CEC Adapter", ENV{DEVNUM}=="000", ATTR{bConfigurationValue}=="1", ATTR{bConfigurationValue}="1"
      '';
    }
  );

  cec-permissions = (
    pkgs.writeTextFile {
      name = "cec-permissions";
      destination = "/etc/udev/rules.d/cec-permissions.rules";
      text = ''
        # Add udev rule to set proper permissions for CEC devices
        # Set permissions for CEC devices
        KERNEL=="cec[0-9]*", GROUP="cec", MODE="0664"
      '';
    }
  );
in
{

  options = {
    my.cec-pulseeight.enable = lib.mkEnableOption "CEC Pulse8 Adapter";
  };

  config = lib.mkIf config.my.cec-pulseeight.enable {
    # https://wiki.archlinux.org/title/HDMI-CEC#PulseEight_USB_adapter
    # https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4#HDMI-CEC

    environment.systemPackages = with pkgs; [
      libcec
      v4l-utils
      linuxConsoleTools
    ];

    # Systemd service template for attaching the CEC adapter
    systemd.services."pulse8-cec-attach@" = {
      description = "Configure USB Pulse-Eight serial device at %I";
      unitConfig = {
        ConditionPathExists = "%I";
      };
      serviceConfig = {
        Type = "forking";
        # inputattach doesn't have systemd daemon support, so systemd guesses the PID
        ExecStart = "${pkgs.linuxConsoleTools}/bin/inputattach --daemon --pulse8-cec %I";
        RemainAfterExit = true;
      };
    };

    # Optional: CEC client socket and service for network access
    systemd.sockets."cec-client" = {
      description = "CEC Client Socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "9526";
        Accept = true;
      };
    };

    systemd.services."cec-client@" = {
      description = "CEC Client Service";
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.libcec}/bin/cec-client -d 8";
        StandardInput = "socket";
        StandardOutput = "socket";
        StandardError = "journal";
        User = "nobody";
        Group = "nobody";
      };
    };

    # Ensure the user running CEC applications is in the right groups
    users.groups.cec = { };

    services.udev.packages = [
      pulse8-cec-autoattach
      cec-permissions
    ];

  };
}
