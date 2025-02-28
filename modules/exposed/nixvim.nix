{
  lib,
  pkgs,
  ...
}: {
  options = {};
  config = {
    autoCmd = [
      {
        command = "lua vim.lsp.buf.format()";
        event = ["BufWritePre"];
        pattern = ["*.nix"];
      }
    ];
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    colorscheme = lib.mkForce "solarized-flat";
    keymaps = [
      {
        action = ":m .+1<CR>==";
        key = "<A-j>";
        mode = "n";
      }
      {
        action = "<Esc>:m .+1<CR>==gi";
        key = "<A-j>";
        mode = "i";
      }
      {
        action = ":m '>+1<CR>gv=gv";
        key = "<A-j>";
        mode = "v";
      }
      {
        action = ":m .-2<CR>==";
        key = "<A-k>";
        mode = "n";
      }
      {
        action = "<Esc>:m .-2<CR>==gi";
        key = "<A-k>";
        mode = "i";
      }
      {
        action = ":m '<-2<CR>gv=gv";
        key = "<A-k>";
        mode = "v";
      }
      {
        action = "<C-\\><C-n>";
        key = "<Esc>";
        mode = "t";
      }
      {
        action = "<cmd>Neotree reveal toggle<CR>";
        key = "<leader>n";
        mode = "n";
      }
      {
        action = "<cmd>Neotree buffers reveal toggle<CR>";
        key = "<leader>bn";
        mode = "n";
      }
      {
        action = "<cmd>Neotree git_status reveal toggle<CR>";
        key = "<leader>gn";
        mode = "n";
      }
    ];
    opts = {
      background = "light";
      expandtab = true;
      foldlevel = 99;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      smartindent = true;
      softtabstop = 2;
      tabstop = 2;
    };
    extraConfigLuaPost = ''
    '';
    extraConfigVim = ''
    '';
    extraPlugins = with pkgs.vimPlugins; [nvim-solarized-lua];
    plugins = {
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      cmp = {
        enable = true;
        autoEnableSources = false;
        settings = {
          formatting = {
            fields = ["abbr" "kind" "menu"];
            expandable_indicator = true;
          };
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          sources = [
            {
              name = "buffer";
              priority = 4;
            }
            {
              name = "luasnip";
              priority = 3;
            }
            {
              name = "nvim_lsp";
              priority = 10;
            }
            {
              name = "path";
              priority = 5;
            }
          ];
          window = {
            completion = {
              border = "rounded";
            };
            documentation.border = "rounded";
          };
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      cmp-path.enable = true;
      luasnip = {
        enable = true;
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };
      friendly-snippets.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix"];
        };
      };
      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[API]";
            path = "[PATH]";
            luasnip = "[SNIP]";
            buffer = "[BUFFER]";
          };
        };
      };
      lsp = {
        enable = true;
        inlayHints = true;
        keymaps = {
          lspBuf = {
            K = "hover";
            gd = "definition";
            gD = "references";
            gi = "implementation";
            gt = "type_definition";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "<leader>gf" = "format";
          };
        };
        servers.nixd = {
          enable = true;
          settings = {
            formatting.command = ["alejandra"];
            nixpkgs.expr = "import (builtins.getFlake \"/home/igmar/nixos\").inputs.nixpkgs { }";
            options.nixos.expr = "(builtins.getFlake \"/home/igmar/nixos\").nixosConfigurations.default.options";
          };
        };
      };
      lualine = {
        enable = true;
        settings.options.theme = "solarized_light";
      };
      neo-tree = {
        enable = true;
        popupBorderStyle = "rounded";
        window.position = "right";
      };
      telescope = {
        enable = true;
        extensions = {
          live-grep-args.enable = true;
          ui-select.enable = true;
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            mode = "n";
          };
          "<leader>fg" = {
            action = "live_grep";
            mode = "n";
          };
          "<leader>fb" = {
            action = "buffers";
            mode = "n";
          };
          "<leader>fh" = {
            action = "help_tags";
            mode = "n";
          };
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
        ];
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<CR>";
              node_decremental = "<C-j>";
              node_incremental = "<C-k>";
              scope_incremental = "<C-h>";
            };
          };
        };
      };
      web-devicons.enable = true;
    };
  };
}
