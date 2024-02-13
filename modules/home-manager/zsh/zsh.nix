{ config, lib, pkgs, pkgs-unstable, ...}:
{
  imports = [
    ./zshenv.nix
    ./zprofile.nix
  ];
  
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza -a --icons --group-directories-first";
      rm = "rm -I";
      vim = "nvim";
      update = "sh -c 'sudo nixos-rebuild switch --flake .#$(hostname)'";
      update-user = "sh -c ' rm -rf ~/.config/gtk-2.0/ && home-manager switch --flake .#$(whoami)@$(hostname)'";
    };
    

    # Manual lines in .zshrc file
    initExtra = ''
      [[ ! -f ${./files/p10k.zsh} ]] || source ${./files/p10k.zsh}
      source $ZDOTDIR/scripts/sweet_sentences.sh 
    '';


    plugins = with pkgs; [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
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
  
  home.packages = (with pkgs; [
    lolcat
    cowsay
    # exa
  ])
  ++
  (with pkgs-unstable;[
    eza
  ]);

  # Scripts
  xdg.configFile."./zsh/scripts".source = ./files/scripts;
  xdg.configFile."./zsh/scripts".recursive = true;

  # Cows
  xdg.dataFile."./cowsay".source = ./files/cows;
  xdg.dataFile."./cowsay".recursive = true;
}
