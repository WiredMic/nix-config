{
  lib,
  fetchFromGitHub,
  buildDotnetModule,

  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,

  # deps
  fontconfig,
  libX11,
  libICE,
  libSM,
  icu,
}:

let
in
buildDotnetModule (finalAttrs: {
  pname = "quiver-launcher";
  version = "3.4.5";

  src = fetchFromGitHub {
    repo = "quiver-launcher";
    owner = "tgeorgiadis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PsfHU0sNrDS8Vwz1VSlNAv2qQwKpGxQp14/7ERnya4k=";
  };

  projectFile = "QuiverLauncher.Desktop/QuiverLauncher.Desktop.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  runtimeDeps = [
    icu
    fontconfig
    libX11
    libICE
    libSM
  ];

  makeWrapperArgs = [ "--set QuiverLauncher_SKIP_UPDATES 1" ];

  # Test suite crashes at process teardown (exit 139) regardless of which
  # tests run - looks like a native-library (Avalonia headless / Skia)
  # shutdown issue in the build sandbox, not a packaging problem. See
  # LinuxLauncherScriptTests etc. for prior investigation.
  doCheck = false;

  executables = [ "QuiverLauncher" ];

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "quiver-launcher";
      desktopName = "Quiver Launcher";
      comment = "Download, install and run apps from GitHub and GitLab releases";
      exec = "QuiverLauncher";
      icon = "quiver-launcher";
      categories = [
        "Game"
        "Utility"
      ];
    })
  ];

  postInstall = ''
    install -Dm444 Assets/quiver-icon.png $out/share/pixmaps/quiver-launcher.png
  '';

  meta = {
    description = "Quiver launcher";
    homepage = "https://www.quiverlauncher.com/";
    mainProgram = "QuiverLauncher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ WiredMic ];
    platforms = lib.platforms.all;
  };
})
