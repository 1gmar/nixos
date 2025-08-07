{
  config,
  lib,
  pkgs,
  ...
}: {
  options.nushell = {
    enable = lib.mkEnableOption "enable nushell module";
  };
  config = lib.mkIf config.nushell.enable {
    nixvim = {
      treesitterGrammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nu];
      extensions = {
        lsp.servers.nushell = {
          enable = true;
          settings = {
            cmd = ["nu" "--lsp"];
            filetypes = ["nu"];
            root_dir.__raw = ''
              function(bufnr, on_dir)
                on_dir(vim.fs.root(bufnr, { '.git' }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
              end
            '';
          };
        };
      };
    };
    programs.nushell = {
      enable = true;
      extraConfig = ''
        use std/config light-theme
        $env.config = {
          color_config: (light-theme)
        }
      '';
    };
  };
}
