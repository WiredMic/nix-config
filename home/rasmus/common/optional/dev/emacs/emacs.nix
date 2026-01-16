{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  treesitterGrammars = pkgs.emacsPackages.treesit-grammars.with-grammars (
    grammars: with grammars; [
      tree-sitter-typst
      tree-sitter-nix
      tree-sitter-rust
      tree-sitter-cpp
      tree-sitter-c

      tree-sitter-toml
      tree-sitter-yaml
    ]
  );
in
{

  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  options = {
    my.emacs.enable = lib.mkEnableOption "enables emacs";
  };

  config = lib.mkIf config.my.emacs.enable {

    programs.emacs = {
      enable = true;
      package = pkgs.emacs.override {
        withPgtk = true;
        withTreeSitter = true;
        withNativeCompilation = true;
        withDbus = true;
      };
      extraPackages = epkgs: with epkgs; [ ];
    };

    services.emacs = {
      enable = true;
      package = if config.programs.emacs.enable then config.programs.emacs.package else pkgs.emacs;
      socketActivation.enable = true;
    };

    home.sessionVariables = {
      EDITOR = lib.mkForce "emacsclient";
      VISUAL = lib.mkForce "emacsclient -nc";
      TREE_SITTER_GRAMMAR_DIR = "${treesitterGrammars}/lib";
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
      nodePackages.prettier # YAML, Markdown
      dockfmt # Dockerfile
      nixfmt-rfc-style # nix
      # rPackages.lintr # R

      # lsp
      nixd # nix
      shfmt # sh
      clang-tools # c/cpp/objc
      ccls
      pyright # Python
      # rPackages.languageserver # R
      openscad-lsp # openSCAD
      nodejs_24
      matlab-language-server
      vhdl-ls # vhdl
      emacs-lsp-booster # speed up lsp

      # Typst
      # tree-sitter-grammars.tree-sitter-typst # tree-sitter
      tinymist # lsp
      typstyle # formatter

      # LaTeX
      texlab

      # Python
      black
      python313Packages.pyflakes
      isort
      pipenv
      python313Packages.pytest

      ghdl
      # Programming languages
      # R

      # dependencies
      anki-bin
      ripgrep
      fd
      ispell
      pandoc
      graphviz
      clang # c format
      glslang
      gnumake
    ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/rasmus/common/optional/dev/emacs/doom";
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
