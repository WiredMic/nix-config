{
  pkgs,
  lib,
  config,
  ...
}:
{
  

  options = {
    my.emacs.enable =
      lib.mkEnableOption "enables emacs";
  };

  config = lib.mkIf config.my.direnv.enable {
    programs.emacs.enable = true;
    services.emacs.socketActivation.enable = true;

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # fonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      jetbrains-mono
      fira

      # dependencies
      ripgrep
      fd
      ispell
      pandoc
      graphviz
      shellcheck
      python312Packages.editorconfig
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      #format https://docs.doomemacs.org/latest/modules/editor/format/
      nixfmt-classic # nix
      texlivePackages.latexindent # LaTeX
      nodePackages.prettier # YAML, Markdown
      dockfmt # Dockerfile
      # lsp
      nil # nix
      
      
    ];

    systemd.user.sessionVariables = {
      PATH = "\${xdg.configHome}/emacs/bin/:$PATH";
    };
    

    xdg.configFile."doom" = {
      enable = true;
      source = ./doom-emacs;
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

    # xdg.configFile."doom".source = pkgs.stdenv.mkDerivation {
    #   name = "doom-emacs";
    #   dontUnpack = true;
    #   src = pkgs.fetchurl {
    #     url = "https://raw.githubusercontent.com/doomemacs/doomemacs/screenshots/cacochan.png";
    #     hash = "sha256-SNePEot4Pb7+Ci4clK8fFEVdzxSu0GGHvrFbEjVMrg4=";
    #   };
    #
    #   installPhase = ''
    #   mkdir -p $out
    #   cp -r $src $out/
    #   cp -r ${./doom-emacs}/* $out/
    #   '';
    # };
  };
}
