{
  config,
  lib,
  pkgs,
  ...
}:
let
  installFont = pkgs.callPackage ./packages/install-font.nix { };
  free-japanese-fonts = installFont {
    pname = "free-japanese-fonts";
    src = ./packages/fonts/free-japanese-fonts.tar.gz;
  };
in
{
  options.font-config = {
    enable = lib.mkEnableOption "enable fonts module";
    extra-jp-fonts = lib.mkEnableOption "install extra Japanese fonts";
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
      packages =
        with pkgs;
        (
          [
            adwaita-fonts
            corefonts
            fira
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            vista-fonts
          ]
          ++ (
            if config.font-config.extra-jp-fonts then
              [
                free-japanese-fonts
                kochi-substitute
                ipaexfont
                jigmo
                ricty
                takao
                (zpix-pixel-font.overrideAttrs {
                  installPhase = ''
                    runHook preInstall
                    install -Dm444 ''${srcs[1]} $out/share/fonts/truetype/zpix.ttf
                    runHook postInstall
                  '';
                })
              ]
            else
              [ ]
          )
        );
    };
    unfree-apps.pkg-names = [
      "corefonts"
      "ricty"
      "vista-fonts"
      "zpix-pixel-font"
    ];
  };
}
