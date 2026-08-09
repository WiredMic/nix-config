{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  options = {
    my.zsh.enable = lib.mkEnableOption "enables my zsh config";
  };

  config = lib.mkIf config.my.zsh.enable {

    home.packages =
      (with pkgs; [
        eza
        bat
      ])
      ++ (with pkgs-unstable; [
        # eza
      ]);

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = rec {
        ls = "eza -a --icons --group-directories-first";
        ll = "eza -a --icons --group-directories-first -l";
        rm = "rm -I";
        vim = "nvim";
        tree = "eza --tree";
        cat = "bat -p --color=always -P";
        wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
        matlab = ''octave -q --eval "PS1('matlab:\#> ')" --persist'';
        matlab-cli = "matlab";
        nix = "noglob nix";
        nom = "noglob nom";
      };

      # Manual lines in .zshrc file
      initContent = ''
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      '';

      plugins = with pkgs; [
        {
          name = "zsh-abbrev-alias";
          src = fetchFromGitHub {
            owner = "momo-lab";
            repo = "zsh-abbrev-alias";
            rev = "637f0b2dda6d392bf710190ee472a48a20766c07";
            sha256 = "16saanmwpp634yc8jfdxig0ivm1gvcgpif937gbdxf0csc6vh47k";
          };
          file = "abbrev-alias.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
            sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
          };
          file = "autopair.zsh";
        }
        {
          name = "powerlevel10k";
          src = zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      history = {
        path = "$HOME/.config/zsh/.zsh_history";
        save = 10000;
        share = true;
      };
    };
  };
}
