{
  installFonts,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "noto-sans-jp";
  version = "1.0";
  src = ./fonts/notosansjp;

  nativeBuildInputs = [ installFonts ];

  meta = with lib; {
    description = "Noto Sans Japanese";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+JP";
    platforms = platforms.all;
  };
}
