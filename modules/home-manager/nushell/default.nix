{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nushell = {
    enable = lib.mkEnableOption "enable nushell module";
  };
  config = lib.mkIf config.nushell.enable {
    home.packages = [
      (pkgs.writers.makeScriptWriter {
        interpreter = "${lib.getExe pkgs.nushell} --stdin";
      } "/bin/docker-logs-decorator" (builtins.readFile ./docker-logs-decorator.nu))
    ];
    nixvim = lib.mkIf config.nixvim.enable {
      extensions = {
        lsp.servers.nushell = {
          enable = true;
          config = {
            cmd = [
              "nu"
              "--lsp"
            ];
            filetypes = [ "nu" ];
            root_dir.__raw = ''
              function(bufnr, on_dir)
                on_dir(vim.fs.root(bufnr, { '.git' }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
              end
            '';
          };
        };
      };
      treesitterGrammars = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.nu ];
    };
    programs.kitty = lib.mkIf config.kitty.enable {
      settings.shell = "${config.home.profileDirectory}/bin/nu";
    };
    programs.nushell = {
      enable = true;
      extraConfig =
        lib.mkAfter # nu
          ''
            $env.LS_COLORS = (${lib.getExe pkgs.vivid} generate solarized-light)
            source ${./nix.nu}
            source ${./prompt.nu}
            source ${./solarized-light.nu}
          '';
      settings = {
        show_banner = false;
        use_kitty_protocol = true;
      };
    };
  };
}
