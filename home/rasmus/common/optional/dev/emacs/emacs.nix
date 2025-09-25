{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  options = {
    my.emacs.enable = lib.mkEnableOption "enables emacs";
  };

  config = lib.mkIf config.my.emacs.enable {

    # programs.emacs = {
    #   enable = true;
    #   package = pkgs.emacsWithPackagesFromUsePackage {
    #     # We use the README.org directly. The file will be tangled automatically,
    #     # that is, the source code blocks are going to be extracted.
    #     config = ./README.org;

    #     # workaround for making stylix work with emacs-overlay
    #     # config = pkgs.writeTextFile {
    #     #   text = ''
    #     #     ${builtins.readFile ./README.org}
    #     #      #+begin_src emacs-lisp
    #     #     ${config.programs.emacs.extraConfig}
    #     #      #+end_src'';
    #     #   name = "config.org";
    #     # };

    #     # Include the config as a default init file
    #     defaultInitFile = true;

    #     # Package is optional, defaults to pkgs.emacs
    #     package = pkgs.emacs.override {
    #       withPgtk = true;
    #       withTreeSitter = true;
    #     };

    #     # By default emacsWithPackagesFromUsePackage will only pull in
    #     # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
    #     # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
    #     # and pulls in all use-package references not explicitly disabled via
    #     # `:ensure nil` or `:disabled`.
    #     # Note that this is NOT recommended unless you've actually set
    #     # `use-package-always-ensure` to `t` in your config.
    #     alwaysEnsure = true;

    #     # For Org mode babel files, by default only code blocks with
    #     # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
    #     # will include all code blocks missing the `:tangle` argument,
    #     # defaulting it to `yes`.
    #     # Note that this is NOT recommended unless you have something like
    #     # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
    #     # which defaults `:tangle` to `yes`.
    #     alwaysTangle = true;

    #     # Override to include custom packages
    #     override =
    #       epkgs:
    #       epkgs
    #       // {
    #         org-modern-indent = pkgs.callPackage ./externalPackages/org-modern-indent.nix {
    #           inherit (pkgs) fetchFromGitHub;
    #           inherit (epkgs) trivialBuild compat;
    #         };

    #         org = pkgs.callPackage ./externalPackages/org-latex-preview.nix {
    #           inherit (pkgs)
    #             lib
    #             fetchgit
    #             stdenv
    #             emacs
    #             texinfo
    #             gnumake
    #             git
    #             ;
    #           org = epkgs.org; # Pass original for reference
    #         };
    #       };

    #     # Optionally provide extra packages not in the configuration file.
    #     extraEmacsPackages =
    #       epkgs:
    #       with epkgs;
    #       [
    #         # packages from melpa (pre-requisites)
    #         # TODO can I just move them into config.el?
    #         treesit-grammars.with-all-grammars
    #         use-package
    #         general
    #         evil
    #         evil-collection
    #         evil-commentary
    #         evil-surround
    #         which-key

    #         # UI packages
    #         doom-themes
    #         doom-modeline
    #         catppuccin-theme
    #         dashboard
    #         ligature
    #         nerd-icons

    #         # Completion
    #         vertico
    #         consult
    #         marginalia
    #         embark
    #         embark-consult
    #         orderless

    #         # Development
    #         lsp-mode
    #         lsp-ui
    #         dap-mode
    #         company
    #         company-box
    #         flycheck
    #         flycheck-popup-tip
    #         format-all
    #         direnv
    #         projectile
    #         consult-projectile

    #         # Language support
    #         nix-mode
    #         rust-mode

    #         # Org mode extensions
    #         org-modern
    #         org-modern-indent
    #         org-download
    #         toc-org
    #         evil-org
    #         org-roam
    #         org-roam-ui
    #         websocket
    #         olivetti
    #         org-appear
    #         org-transclusion
    #         company-org-block
    #         valign

    #         ## Agenda
    #         org-fancy-priorities

    #         # Other utilities
    #         no-littering
    #         exec-path-from-shell
    #         clipetty
    #         peep-dired
    #         pdf-tools

    #       ]
    #       # workaround for making stylix work with emacs-overlay
    #       ++ (config.programs.emacs.extraPackages epkgs);

    #     # Optionally override derivations.
    #     # override =
    #     #   epkgs:
    #     #   epkgs
    #     #   // {
    #     #     lsp-install-servers = epkgs.trivialBuild {
    #     #       pname = "lsp-install-servers";
    #     #       version = "1.0";
    #     #       src = pkgs.writeText "lsp-install-servers.el" ''
    #     #         (eval-after-load 'lsp-mode
    #     #          '(progn
    #     #            (lsp-dependency 'omnisharp '(:system "${pkgs.omnisharp-roslyn}/bin/omnisharp"))
    #     #            (lsp-dependency 'lua-language-server '(:system "${pkgs.lua-language-server}/bin/lua-language-server"))))
    #     #
    #     #         (provide 'lsp-install-servers)
    #     #       '';
    #     #       packageRequires = [ epkgs.lsp-mode ];
    #     #     };
    #     #
    #     #     # unfortunately, I have to add the packages from the epkgs-overlay
    #     #     # here manually. Apparently, emacs-overlay does not take them
    #     #     # into account on its own.
    #     #     inherit (pkgs.emacsPackages) copilot;
    #     #   };
    #   };
    # };

    programs.emacs = {
      enable = true;
      package =
        # (pkgs.emacsPackagesFor (
        #   pkgs.emacs.override {
        #     withPgtk = true;
        #     withTreeSitter = true;
        #   }
        # )).emacsWithPackages
        #   (
        #     epkgs: with epkgs; [
        #       base16-theme
        #       (treesit-grammars.with-grammars (
        #         grammars: with grammars; [
        #           tree-sitter-typst
        #           tree-sitter-nix
        #           # tree-sitter-python
        #           # add other grammars you need
        #         ]
        #       ))
        #     ]
        #   );

        pkgs.emacs.override {
          withPgtk = true;
          withTreeSitter = true;
        };
      extraPackages =
        epkgs: with epkgs; [
          (treesit-grammars.with-grammars (
            grammars: with grammars; [
              tree-sitter-typst
              tree-sitter-nix
            ]
          ))
        ];
    };

    services.emacs = {
      enable = true;
      package = if config.programs.emacs.enable then config.programs.emacs.package else pkgs.emacs;
      socketActivation.enable = true;
    };

    home.sessionVariables = {
      EDITOR = lib.mkForce "emacsclient";
      VISUAL = lib.mkForce "emacsclient -nc";
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
      texlivePackages.latexindent # LaTeX
      nodePackages.prettier # YAML, Markdown
      dockfmt # Dockerfile
      texlivePackages.latexindent # LaTeX
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

      # Python
      black
      python313Packages.pyflakes
      isort
      pipenv
      python313Packages.pytest

      # Programming languages
      # R

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
    ];

    # programs.doom-emacs = {
    #   enable = true;
    #   doomDir = ./doom.d; # or e.g. `./doom.d` for a local configuration
    #   doomLocalDir = "${config.xdg.dataHome}/nix-doom";
    #   provideEmacs = false;
    #   tangleArgs = ".";
    #   extraBinPackages = with pkgs; [
    #     # dependencies
    #     anki
    #     ripgrep
    #     fd
    #     ispell
    #     pandoc
    #     graphviz
    #     clang # c format
    #     glslang
    #     gnumake
    #   ];
    # };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      enable = true;
      source = ./doom;
      # onChange = "~/.config/emacs/bin/doom sync";
      recursive = true;
    };

  };
}
