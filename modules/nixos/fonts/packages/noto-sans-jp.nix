{
  gnutar,
  installFonts,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "noto-sans-jp";
  version = "1.0";
  src = ./fonts/notosansjp.tar.gz;

  nativeBuildInputs = [
    gnutar
    installFonts
  ];

  unpackPhase = ''
    runHook preUnpack
    tar -xvzf $src
    runHook postUnpack
  '';

  meta = with lib; {
    description = "Noto Sans Japanese";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+JP";
    platforms = platforms.all;
  };
}
