{
  pkgs,
  lib,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "hiragino-fonts";
  version = "1.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    if [ -d "$src/fonts" ]; then
      cp -r $src/fonts/*.otf $out/share/fonts/truetype/
    else
      echo "No fonts found in $src/fonts"
      exit 0
    fi
  '';

  meta = with lib; {
    description = "Hiragino Kaku Gothic Pro Fonts";
    homepage = "https://fontsgeek.com/hiragino-kaku-gothic-pro-font";
    platforms = platforms.all;
  };
}
