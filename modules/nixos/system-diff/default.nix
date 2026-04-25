{
  config,
  lib,
  pkgs,
  shell-theme,
  userName,
  ...
}:
{
  options.system-diff = {
    enable = lib.mkEnableOption "enable system diff module";
  };
  config = lib.mkIf config.system-diff.enable {
    system.activationScripts.system-diff = # bash
      ''
        if [[ -e /run/current-system ]]; then
          ${pkgs.nushell}/bin/nu --config ${shell-theme} ${./system-diff.nu} ${userName}\
            ${pkgs.nix}/bin/nix store diff-closures /run/current-system $systemConfig
        fi
      '';
  };
}
