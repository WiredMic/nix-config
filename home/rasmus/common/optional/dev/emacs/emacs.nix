{ pkgs, lib, config, inputs, ... }: {

  options = { my.emacs.enable = lib.mkEnableOption "enables emacs"; };

  config = lib.mkIf config.my.direnv.enable {
    programs.emacs = { enable = true; };
    programs.emacs.package = pkgs.emacs29-pgtk;
    services.emacs.socketActivation.enable = true;

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # fonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      jetbrains-mono
      fira

      # dependencies
      anki
      ripgrep
      fd
      ispell
      pandoc
      graphviz
      clang # c format
      glslang
      gnumake

      # Spellcheck
      shellcheck
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science da ]))

      # Format https://docs.doomemacs.org/latest/modules/editor/format/
      texlivePackages.latexindent # LaTeX
      nodePackages.prettier # YAML, Markdown
      dockfmt # Dockerfile
      texlivePackages.latexindent # LaTeX

      # lsp
      nil # nix
      # nixd # nix
      shfmt # sh
      dap # A debugger
      clang-tools # c/cpp/objc

      # autofmt
      nixfmt # nix
      # nixfmt-rfc-style # new nix format
    ];

    # nixd for NixOS
    # nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      enable = true;
      source = ./doom-emacs;
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
