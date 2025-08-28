{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bat = {
    enable = lib.mkEnableOption "enable bat module";
  };
  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
      config = {
        italic-text = "always";
        pager = "less --raw-control-chars --quit-if-one-screen --mouse";
        theme = "Solarized (light)";
      };
      syntaxes = {
        nushell = {
          src = pkgs.fetchFromGitHub {
            owner = "stevenxxiu";
            repo = "sublime_text_nushell";
            rev = "66b00ff639dc8cecb688a0e1d81d13613b772f66";
            hash = "sha256-paayZP6P+tzGnla7k+HrF+dcTKUyU806MTtUeurhvdg=";
          };
          file = "nushell.sublime-syntax";
        };
      };
    };
  };
}
