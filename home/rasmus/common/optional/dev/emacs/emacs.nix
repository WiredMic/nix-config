{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  inputs,
  userSettings,
  ...
}:
let
  treesitterGrammars = pkgs.emacsPackages.treesit-grammars.with-grammars (
    grammars: with grammars; [
      tree-sitter-nix
      tree-sitter-rust
      tree-sitter-cpp
      tree-sitter-c

      tree-sitter-toml
      tree-sitter-yaml

      tree-sitter-typst
      tree-sitter-markdown
    ]
  );
in
{

  options = {
    my.emacs.enable = lib.mkEnableOption "enables emacs";
  };

  config = lib.mkIf config.my.emacs.enable {

    programs.emacs = {
      enable = true;
      package = pkgs-unstable.emacs.override {
        withPgtk = true;
        withTreeSitter = true;
        withNativeCompilation = true;
        withDbus = true;
      };
      extraPackages =
        epkgs: with epkgs; [
          treesitterGrammars
        ];
    };

    services.emacs = {
      enable = true;
      defaultEditor = userSettings.editor == "emacs";
      socketActivation.enable = true;
      startWithUserSession = true;
    };

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # fonts
      nerd-fonts.symbols-only
      jetbrains-mono
      fira-go

      # Spellcheck
      shellcheck
      (aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          # en-science
          da
        ]
      ))

      # Format https://docs.doomemacs.org/latest/modules/editor/format/
      prettier # YAML, Markdown
      dockfmt # Dockerfile
      # rPackages.lintr # R

      # lsp
      shfmt # sh
      # rPackages.languageserver # R
      nodejs_24
      matlab-language-server
      emacs-lsp-booster # speed up lsp
      cmake-language-server

      # C/C++
      clang-tools # c/cpp/objc
      ccls
      clang # c format

      # Nix
      nixd # lsp
      nixfmt # fmt

      # OpenSCAD
      openscad-lsp # lsp

      # VHDL
      vhdl-ls # lsp
      ghdl

      # Typst
      # tree-sitter-grammars.tree-sitter-typst # tree-sitter
      tinymist # lsp
      typstyle # formatter

      # LaTeX
      texlab

      # Python
      black
      python3Packages.pyflakes
      isort
      pipenv
      python3Packages.pytest
      pyright # lsp

      # Programming languages
      # R

      # just
      just-formatter
      just-lsp

      # PHP
      # php
      # phpPackages.composer
      # Download in flake

      # Anki
      curl

      # dependencies
      ripgrep
      fd
      ispell
      pandoc
      graphviz
      glslang
      gnumake
      python3Packages.editorconfig
    ];

    programs.anki = {
      enable = true;
      package = pkgs.anki;
      addons = with pkgs.ankiAddons; [
        anki-connect
      ];
      language = "en_US";
    };

    home.sessionVariables = {
      ANKI_BASE = "${config.home.homeDirectory}/Org/Anki";
    };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/rasmus/common/optional/dev/emacs/doom";
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
