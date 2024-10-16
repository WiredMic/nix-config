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
      python312Packages.editorconfig
      clang # c format
      glslang

      # Spellcheck
      shellcheck
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science da ]))

      # Format https://docs.doomemacs.org/latest/modules/editor/format/
      nixfmt-classic # nix
      texlivePackages.latexindent # LaTeX
      nodePackages.prettier # YAML, Markdown
      dockfmt # Dockerfile
      texlivePackages.latexindent # LaTeX

      # lsp
      nil # nix
      shfmt # sh
      dap # A debugger
      ccls # c/cpp/objc

      # autofmt
      nixfmt # nix
      # nixfmt-rfc-style # new nix format
      #
    ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      enable = true;
      source = ./doom-emacs;
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
