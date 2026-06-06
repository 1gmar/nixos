{
  config,
  lib,
  pkgs,
  ...
}:
let
  hiragino-kaku-gothic-pro = pkgs.callPackage ./packages/hiragino.nix { };
  noto-sans-jp = pkgs.callPackage ./packages/noto-sans-jp.nix { };
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
          "Noto Sans JP"
          "Noto Sans CJK JP"
        ];
        serif = [
          "Fira Sans"
          "Noto Serif CJK JP"
        ];
      };
      fontDir.enable = true;
      packages = with pkgs; [
        corefonts
        fira
        hiragino-kaku-gothic-pro
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        noto-sans-jp
        vista-fonts
      ];
    };
    unfree-apps.pkg-names = [
      "corefonts"
      "vista-fonts"
    ];
  };
}
