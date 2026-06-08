{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommandLocal,
  antlr4,
  jre,
}:
buildGoModule (finalAttrs: {
  pname = "scadformat";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "hugheaves";
    repo = "scadformat";
    rev = "v${lib.versions.majorMinor finalAttrs.version}";
    hash = "sha256-RRJLeKoROMFWRTYAhue1aJ8baEy3hAkfNToCnIusb/0=";
  };

  vendorHash = "sha256-pGVU/XGY0uSPmMTVMbi5+mzjGN3b0NvA9vtvqXyGBv0=";

  subPackages = [ "cmd" ];

  nativeBuildInputs = [
    antlr4
    jre
  ];

  postPatch = ''
    echo "v${lib.versions.majorMinor finalAttrs.version}" > cmd/version.txt
    substituteInPlace cmd/scadformat.go \
      --replace-fail \
        '//go:generate sh -c "git describe > version.txt"' \
        ""
  '';

  preBuild = ''
    GOFLAGS="" go generate ./...
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/scadformat
  '';

  passthru.tests.basic = runCommandLocal "scadformat-test" { } ''
    echo 'cube( [ 1,2,  3 ] );' | ${lib.getExe finalAttrs.finalPackage} > $out
    grep 'cube' $out
  '';

  meta = {
    description = "CADFormat is a source code formatter / beautifier for OpenSCAD";
    homepage = "https://github.com/hugheaves/scadformat";
    license = lib.licenses.gpl2Only;
    mainProgram = "scadformat";
    maintainers = [ ];
  };
})
