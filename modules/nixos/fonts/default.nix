{
  config,
  lib,
  pkgs,
  ...
}:
let
  line-seed-jp = pkgs.callPackage ./packages/install-font.nix { } {
    pname = "line-seed-jp";
    src = ./packages/fonts/line_seed_jp.tar.gz;
    version = "20241105";
  };
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
        corefonts
        fira
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        line-seed-jp
        vista-fonts
      ];
    };
    unfree-apps.pkg-names = [
      "corefonts"
      "vista-fonts"
    ];
  };
}
