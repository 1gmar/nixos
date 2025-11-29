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
      extensions.nushell.enable = true;
    };
    programs.kitty = lib.mkIf config.kitty.enable {
      settings.shell = "${config.home.profileDirectory}/bin/nu";
    };
    programs.nushell = {
      enable = true;
      environmentVariables = {
        LS_COLORS =
          lib.hm.nushell.mkNushellInline # nu
            ''
              ${lib.getExe pkgs.vivid} generate solarized-light
            '';
      };
      extraConfig =
        lib.mkAfter # nu
          ''
            source ${./keybindings.nu}
            source ${./nix.nu}
            source ${./prompt.nu}
            source ${./solarized-light.nu}
          '';
      plugins = [ pkgs.nushellPlugins.gstat ];
      settings = {
        show_banner = false;
        use_kitty_protocol = true;
      };
      shellAliases = {
        ls = "ls -s";
      };
    };
  };
}
