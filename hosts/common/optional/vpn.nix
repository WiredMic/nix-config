{ config, lib, pkgs, ... }:

{

  options = { my.vpn.enable = lib.mkEnableOption "enables vpns"; };

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
      port = 41641;
      # authKeyFile # use sops
    };

    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
