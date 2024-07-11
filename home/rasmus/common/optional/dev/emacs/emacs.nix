{ pkgs, lib, config, ... }: {

  options = { my.emacs.enable = lib.mkEnableOption "enables emacs"; };

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
      shfmt # sh

    ];

    home.sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    xdg.configFile."doom" = {
      enable = true;
      source = ./doom-emacs;
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
