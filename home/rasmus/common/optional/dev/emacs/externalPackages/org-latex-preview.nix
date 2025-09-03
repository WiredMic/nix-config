# {
#   lib,
#   fetchgit,
#   # Get the original org package to override
#   org,
# }:

# org.overrideAttrs (oldAttrs: rec {
#   pname = "org";
#   version = "dev-f9f909681a051c73c64cc7b030aa54d70bb78f80";

#   src = fetchgit {
#     url = "https://git.tecosaur.net/tec/org-mode.git";
#     rev = "f9f909681a051c73c64cc7b030aa54d70bb78f80";
#     sha256 = "sha256-MbXBcN6PJ1YSZCyxrg5Fng9pVY9X5FHFB+KAFwQu7zQ=";
#   };

#   meta = oldAttrs.meta // {
#     description = "Tecosaur's development branch of Org mode with LaTeX preview improvements";
#     homepage = "https://git.tecosaur.net/tec/org-mode";
#   };
# })
{
  lib,
  fetchgit,
  stdenv,
  emacs,
  texinfo,
  gnumake,
  git,
  # Original org package for reference
  org,
}:

stdenv.mkDerivation rec {
  pname = "emacs-org-latex-preview";
  version = "f9f909681a051c73c64cc7b030aa54d70bb78f80";

  src = fetchgit {
    url = "https://git.tecosaur.net/tec/org-mode.git";
    rev = "f9f909681a051c73c64cc7b030aa54d70bb78f80";
    sha256 = "sha256-MbXBcN6PJ1YSZCyxrg5Fng9pVY9X5FHFB+KAFwQu7zQ=";
  };

  nativeBuildInputs = [
    emacs
    texinfo
    gnumake
    git
  ];

  # Set up the environment as the project expects
  configurePhase = ''
        runHook preConfigure
        
        # Create org-version.el as the installation instructions specify
        cat > org-version.el << 'EOF'
    (defun org-release () "The release version of Org." "dev-${version}")
    (defun org-git-version () "The truncate git commit hash of Org mode." "${builtins.substring 0 7 version}")
    (provide 'org-version)
    EOF

        # Set up make variables to work with Nix environment
        export EMACS=${emacs}/bin/emacs
        export MAKEINFO=${texinfo}/bin/makeinfo
        
        # Configure for our build environment
        cat > local.mk << 'EOF'
    # Nix build configuration
    EMACS = ${emacs}/bin/emacs
    MAKEINFO = ${texinfo}/bin/makeinfo
    prefix = $(out)
    lispdir = $(prefix)/share/emacs/site-lisp/org
    datadir = $(prefix)/share
    infodir = $(datadir)/info

    # Disable some problematic features during build
    BTEST_RE = 
    BTEST_OB_LANGUAGES = 
    EOF

        runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Build using the project's Makefile
    # Use compile-dirty to avoid some dependency issues
    make compile-dirty

    # Build info documentation if possible
    make info || echo "Info generation failed, continuing..."

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Create installation directories
    mkdir -p $out/share/emacs/site-lisp/org
    mkdir -p $out/share/info

    # Install elisp files
    cp -r lisp/*.el* $out/share/emacs/site-lisp/org/
    cp org-version.el $out/share/emacs/site-lisp/org/

    # Install other necessary files
    if [ -d etc ]; then
      mkdir -p $out/share/emacs/site-lisp/org/etc
      cp -r etc/* $out/share/emacs/site-lisp/org/etc/
    fi

    # Install info files if they exist
    if [ -f doc/org.info ]; then
      cp doc/org.info $out/share/info/
    fi

    runHook postInstall
  '';

  # Allow build to continue even with some warnings/errors
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  meta = with lib; {
    description = "Org mode with enhanced LaTeX preview from Tecosaur's development branch";
    homepage = "https://git.tecosaur.net/tec/org-mode";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
