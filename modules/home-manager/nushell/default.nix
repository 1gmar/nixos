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
    home.file = {
      ".config/nushell/scripts/solarized-light.nu".source = ./solarized-light.nu;
      ".config/nushell/scripts/prompt.nu".source = ./prompt.nu;
    };
    nixvim = lib.mkIf config.nixvim.enable {
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
      treesitterGrammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.nu];
    };
    programs.kitty = lib.mkIf config.kitty.enable {
      settings.shell = "${config.home.profileDirectory}/bin/nu";
    };
    programs.nushell = {
      enable = true;
      extraConfig = lib.mkAfter ''
        $env.LS_COLORS = (${lib.getExe pkgs.vivid} generate solarized-light)
        source solarized-light.nu
        source prompt.nu
      '';
      settings = {
        show_banner = false;
      };
    };
  };
}
