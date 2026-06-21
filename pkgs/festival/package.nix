{
  lib,
  stdenv,
  fetchurl,
  symlinkJoin,
  callPackage,
  makeWrapper,

  # Dependencies
  speech-tools,
  ncurses,
  alsa-lib,

  # Tests
  testVersion,
}:
# https://gitlab.archlinux.org/archlinux/packaging/packages/festival/-/blob/main/PKGBUILD?ref_type=heads
stdenv.mkDerivation (finalAttrs: {
  pname = "festival";
  version = "2.5.0";

  srcs = [
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-release.tar.gz";
      hash = "sha256-TJAHQmsSUpBZnZMd9BDi3vUeaKiu69ibSmHHyWwJpLQ=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_CMU.tar.gz";
      hash = "sha256-wZQwkZvKRdU2jNTIKvYVP7zJakh+vTC3i188CHGLfAc=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_OALD.tar.gz";
      hash = "sha256-4zo0U5DUx2+LmHsGpTMrzdCxaM9nyV3cMnD5Fjy+Yfg=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_POSLEX.tar.gz";
      hash = "sha256-58bjZC29Ww1klCvAFamG/dYkSnnlHsLoMJ5j1WnknqM=";
    })
  ];

  sourceRoot = "${finalAttrs.pname}";

  buildInputs = [
    speech-tools
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--libdir=${placeholder "out"}/lib"
  ];

  preConfigure = ''
    # Important: patch the compiled-in default path
     substituteInPlace config/project.mak \
       --replace-fail 'FTLIBDIR = $(FESTIVAL_HOME)/lib' \
                      'FTLIBDIR = ${placeholder "out"}/lib'

    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )

    substituteInPlace configure \
      --replace-fail 'main(){return(0);}' 'int main(){return(0);}'

  '';

  preBuild = ''
    substituteInPlace config/config \
      --replace-fail 'EST=$(TOP)/../speech_tools' 'EST=${
        symlinkJoin {
          name = "speech_tools-merged";
          paths = [
            speech-tools
            speech-tools.dev
          ];
        }
      }'
  '';

  postBuild = ''
    # Compile the docs
    (cd doc && make)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/man/man1
    mv doc/festival.1 doc/festival_client.1 "$out/share/man/man1/"

    mkdir -p "$out"/{bin,doc,lib}
    for d in bin doc lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done
                   
    runHook postInstall
  '';

  passthru.tests.version = testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.pname} --version";
    version = finalAttrs.version;
  };

  passthru.packages = callPackage ./festival-voices-packages.nix { };

  passthru.withVoices =
    voicesFn:
    let
      selectedVoices = voicesFn finalAttrs.passthru.packages;
      extraBins = lib.concatMap (v: v.passthru.extraBinPath or [ ]) selectedVoices;
    in
    symlinkJoin {
      name = "${finalAttrs.pname}-with-voices";
      paths = [ finalAttrs.finalPackage ] ++ selectedVoices;
      meta = finalAttrs.meta;
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/festival \
          --set-default FESTLIBDIR "$out/lib" \
          ${lib.optionalString (extraBins != [ ]) ''--prefix PATH : "${lib.makeBinPath extraBins}"''}
      '';
    };

  meta = {
    description = "Festival is a multi-lingual speech synthesis from the CMU";
    homepage = "http://festvox.org/festival/";
    license = lib.licenses.free;
    mainProgram = "festival";
    maintainers = [ ];
  };
})
