{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
  ];

  options = {
    user.rasmus.enable = lib.mkEnableOption "enables the user rasmus";
  };

  config = lib.mkIf config.user.rasmus.enable {
    nix.settings.trusted-users = [
      "rasmus"
    ];

    users.users = {
      rasmus = {
        # TODO: You can set an initial password for your user.
        # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
        # Be sure to change it (using passwd) after rebooting!
        initialPassword = "passwd";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        ];
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "plugdev"
        ];

      };
    };
  };

}
