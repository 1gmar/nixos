{
  config,
  lib,
  pkgs,
  ...
}:
let
  hiragino-typeface = pkgs.callPackage ./packages/hiragino.nix { };
in
{
  options.font-config = {
    enable = lib.mkEnableOption "enable fonts module";
  };
  config = lib.mkIf config.font-config.enable {
    fonts = {
      fontconfig.defaultFonts = {
        emoji = [
          "Noto Color Emoji"
        ];
        monospace = [
          "Fira Mono"
          "Noto Sans Mono CJK JP"
        ];
        sansSerif = [
          "Fira Sans"
          "Noto Sans CJK JP"
        ];
        serif = [
          "Fira Sans"
          "Noto Serif CJK JP"
        ];
      };
      fontDir.enable = true;
      packages = with pkgs; [
        adwaita-fonts
        cantarell-fonts
        corefonts
        dejavu_fonts
        fira
        hiragino-typeface
        jetbrains-mono
        liberation_ttf
        material-design-icons
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        unifont
        unifont_upper
        vista-fonts
      ];
    };
    unfree-apps.pkg-names = [
      "corefonts"
      "vista-fonts"
    ];
  };
}
