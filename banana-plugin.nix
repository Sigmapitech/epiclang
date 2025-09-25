{
  lib,
  llvmPackages_20,
  ruleset-v4,
  cmake,
}:
llvmPackages_20.stdenv.mkDerivation {
  pname = "banana-plugin";
  version = "4.0-unstable-2025-09-24";

  src = ruleset-v4;

  nativeBuildInputs = [ cmake ];

  buildInputs = with llvmPackages_20; [
    libclang
    libllvm
  ];

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];

  preConfigure = ''
    # The provided CMakeLists.txt is quite bad...
    cp ${./CMakeLists.txt} CMakeLists.txt
  '';

  meta = {
    description = "Clang plugin ruleset of banana";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
