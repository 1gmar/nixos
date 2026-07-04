{
  gnutar,
  installFonts,
  stdenvNoCC,
}:
{
  pname,
  src,
  version ? "1.0",
}:
stdenvNoCC.mkDerivation {
  inherit pname;
  inherit version;
  inherit src;

  nativeBuildInputs = [
    gnutar
    installFonts
  ];

  unpackPhase = ''
    runHook preUnpack
    tar -xvzf $src
    runHook postUnpack
  '';
}
