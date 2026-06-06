{
  pkgs,
  lib,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "hiragino-kaku-gothic-pro";
  version = "1.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    if [ -d "$src/fonts/hiragino" ]; then
      cp -r $src/fonts/hiragino/*.otf $out/share/fonts/opentype/
    else
      echo "No fonts found in $src/fonts/hiragino"
      exit 0
    fi
  '';

  meta = with lib; {
    description = "Hiragino Kaku Gothic Pro Fonts";
    homepage = "https://fontsgeek.com/hiragino-kaku-gothic-pro-font";
    platforms = platforms.all;
  };
}
