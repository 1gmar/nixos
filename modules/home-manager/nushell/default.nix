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
    home = {
      packages = [
        (pkgs.writers.makeScriptWriter {
          interpreter = "${lib.getExe pkgs.nushell} --stdin";
        } "/bin/docker-logs-decorator" (builtins.readFile ./docker-logs-decorator.nu))
      ];
      shell.enableNushellIntegration = true;
    };
    nixvim.extensions.nushell.enable = true;
    programs = {
      kitty.settings.shell = "${config.home.profileDirectory}/bin/nu";
      nushell = {
        enable = true;
        environmentVariables = {
          LS_COLORS =
            lib.hm.nushell.mkNushellInline # nu
              ''
                ${lib.getExe pkgs.vivid} generate solarized-light
              '';
        };
        extraConfig =
          lib.mkBefore # nu
            ''
              use ${./nix.nu} *
              use ${./prompt.nu}
              use ${./solarized-light.nu}
              source ${./keybindings.nu}
            '';
        plugins = [ pkgs.nushellPlugins.gstat ];
        settings = {
          show_banner = false;
          use_kitty_protocol = true;
        };
        shellAliases = {
          gs = "git status";
          lss = "ls -s";
        };
      };
    };
  };
}
