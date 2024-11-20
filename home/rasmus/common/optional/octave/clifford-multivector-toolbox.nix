{ buildOctavePackage, lib, fetchurl }:

buildOctavePackage rec {
  pname = "clifford-multivector-toolbox";
  version = "2.1";

  src = fetchurl {
    url =
      "https://sourceforge.net/projects/clifford-multivector-toolbox/files/clifford_2_1.zip";
    hash = "sha256-xxKFU/Fem6nMcK0RnYOdHEGcFm33vPLV+9/gK7y2QU4=";
  };

  # Octave replaced many of the is_thing_type check function with isthing.
  # The patch changes the occurrences of the old functions.
  patchPhase = ''
    sed -i s/is_numeric_type/isnumeric/g src/*.cc
    sed -i s/is_real_type/isreal/g src/*.cc
    sed -i s/is_bool_type/islogical/g src/*.cc
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/clifford-multivector-toolbox/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehitzer sangwine ];
    description = "A toolbox for computing with Clifford algebras in MATLAB ";
  };
}
