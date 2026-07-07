{
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
    installFonts
  ];

  sourceRoot = ".";
}
