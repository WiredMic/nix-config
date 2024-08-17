{ config, lib, pkgs, ... }:

{
  options = {
    my.cowsay-shell-script.enable =
      lib.mkEnableOption "enables cowsay when starting a new shell";
  };

  config = lib.mkIf config.my.cowsay-shell-script.enable {

    home.packages = [
      (pkgs.writeShellScriptBin "cowsay-shell-script" ''
        (
        shuf -n 1 << EOF
        Remember to ask about my day!
        I luvvve u
        Hello beautiful
        Min elskede Rasmus
        Hej rapanden Rasmus
        Hvad så prutskid
        Davs med dig
        Hellllllllllllllo
        Wha saaaa
        Husk ikke at gå for sent i seng
        Ostemanden rasmus
        I chose you
        heyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
        EOF
        ) | ${pkgs.cowsay}/bin/cowsay -f $(ls ${
          ./cows
        } | shuf -n 1) | ${pkgs.lolcat}/bin/lolcat
      '')
    ];

    programs.zsh.initExtra = ''
      source cowsay-shell-script
    '';

  };
}
