{ pkgs, lib, config, inputs, ... }: {

  options = { my.emacs.enable = lib.mkEnableOption "enables emacs"; };

  config = lib.mkIf config.my.direnv.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
    };

    services.emacs = {
      enable = true;
      package = if config.programs.emacs.enable then
        config.programs.emacs.package
      else
        pkgs.emacs;
      socketActivation.enable = true;
    };

    home.sessionVariables = {
      EDITOR = lib.mkForce "emacsclient";
      VISUAL = lib.mkForce "emacsclient -nc";
    };

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
      nixfmt # nix
      # rPackages.lintr # R

      # lsp
      nil # nix
      # nixd # nix
      shfmt # sh
      dap # A debugger
      clang-tools # c/cpp/objc
      pyright # Python
      # rPackages.languageserver # R

      # Programming languages
      # R
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
