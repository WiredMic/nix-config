{
  pkgs,
  config,
  lib,
  ...
}:
{

  options = {
    my.neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.my.neovim.enable {
    # https://nvf.notashelf.dev/
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          vimAlias = true;
          theme = {
            enable = true;
            # name = "dracula";
            # style = "dark";
          };

          globals.mapleader = " ";

          statusline.lualine.enable = true;
          telescope = {
            enable = true;
            mappings = {
              findFiles = "<leader>.";
              findProjects = "<leader>pf";
            };
          };

          snippets.luasnip.enable = true;

          comments.comment-nvim = {
            enable = true;
          };

          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers.wl-copy.enable = true;
          };

          autopairs.nvim-autopairs.enable = true;

          autocomplete.nvim-cmp = {
            enable = true;
            # Completion sources
            sources = {
              nvim-cmp-lsp = "[LSP]";
              nvim-cmp-buffer = "[Buffer]";
              nvim-cmp-path = "[Path]";
              nvim-cmp-treesitter = "[TS]";
              luasnip = "[LuaSnip]";
            };

          };

          lsp = {
            enable = true;
            formatOnSave = false; # Like your Doom selective formatting

            servers.tinymist = lib.mkForce {
              enable = true;
              cmd = [ (lib.getExe pkgs.tinymist) ];
              filetypes = [ "typst" ];
              root_markers = [ ".git" ];

              # Add settings here
              settings = {
                projectResolution = "lockDatabase"; # or "singleFile"
                formatterMode = "typstyle";
                exportPdf = "onType"; # or "onSave" or "never"
                semanticTokens = "disable";
              };
            };
          };

          languages = {
            nix = {
              enable = true;
              lsp = {
                enable = true;
                servers = [ "nil" ];
              };
              treesitter = {
                enable = true;
              };
            };

            rust = {
              enable = true;
              lsp.enable = true;
              treesitter = {
                enable = true;
              };
            };

            typst = {
              enable = true;
              lsp = {
                enable = true;
                servers = [ "tinymist" ];
              };
              treesitter = {
                enable = true;
                package = pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst;
              };
            };
          };
        };
      };
    };

  };
}
