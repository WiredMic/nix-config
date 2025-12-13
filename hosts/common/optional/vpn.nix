{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.vpn = {
      enable = lib.mkEnableOption "enables vpns";
      # Here should be the oneOf
      role = lib.mkOption {
        type = lib.types.enum [
          "none"
          "client"
          "server"
          "both"
        ];
        default = "none";
        description = "A wrapper around tailscale, so that I can use this config for both my server and computers";
      };
    };
  };

  config = lib.mkIf config.my.vpn.enable {
    # VPNs
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    # allow the tailscale daemon to bypass the VPN
    # $ mullvad split-tunnel pid add (pgrep tailscaled)

    # SSH through tailscale
    # $ sudo mullvad-exclude ssh remoteuser@remotetailscaleip

    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      extraSetFlags = [ "--exit-node-allow-lan-access" ];
      port = 41641;
      openFirewall = true;
      useRoutingFeatures = config.my.vpn.role;
      interfaceName = "tailscale0";
      # authKeyFile # use sops
    };
    networking.firewall = {
      checkReversePath = "loose";
    };
  };
}
