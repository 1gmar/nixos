{
  fetchFromGitHub,
  kernel,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "applesmc-next";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "netlinux-ai";
    repo = "applesmc-next";
    rev = "5057f2029349c11f01715a4a42bf0cce5a9db78c";
    hash = "sha256-rfshnoWyZdMJ8+8zzL+x0gewfhYC7HtQauuf8L+a6AI=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild
    make \
      KVER=${kernel.modDirVersion} \
      KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion} \
      KBUILD_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dst=$out/lib/modules/${kernel.modDirVersion}/updates
    mkdir -p "$dst"
    find . -name '*.ko' -exec cp -v '{}' "$dst"/ \;
    runHook postInstall
  '';

  meta = with lib; {
    platform = platforms.linux;
  };
}
