{
  lib,
  trivialBuild,
  fetchFromGitHub,
  compat,
}:

trivialBuild rec {
  pname = "org-modern-indent";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "org-modern-indent";
    rev = "v${version}";
    sha256 = "sha256-st3338Jk9kZ5BLEPRJZhjqdncMpLoWNwp60ZwKEObyU=";
  };

  # Declare package dependencies
  packageRequires = [ compat ];

  meta = with lib; {
    description = "Modern block styling with indentation for Org";
    homepage = "https://github.com/jdtsmith/org-modern-indent";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
