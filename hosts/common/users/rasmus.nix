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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEu1C0iL1LjGgO04d3DmQ33uB4EF70oQ7Jfpa1ccSEky rasmus@enev.dk"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEag9yiSIgqNyI+Vo+W+vuDYJj1FMJUWPFBhz1No1bky rasmus@enev.dk"
        ];
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "plugdev"
          "uinput"
        ];

      };
    };
  };

}
