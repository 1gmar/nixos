{
  pkgs,
  lib,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "noto-sans-jp";
  version = "1.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    if [ -d "$src/fonts/notosansjp" ]; then
      cp -r $src/fonts/notosansjp/*.ttf $out/share/fonts/truetype/
    else
      echo "No fonts found in $src/fonts/notosansjp"
      exit 0
    fi
  '';

  meta = with lib; {
    description = "Noto Sans Japanese";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+JP";
    platforms = platforms.all;
  };
}
