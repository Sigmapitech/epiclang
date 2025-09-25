{
  lib,
  clangStdenv,
  clang_20,
  ruleset-v4,
  cmake,
  llvmPackages_20,
}:
clangStdenv.mkDerivation {
  pname = "banana-plugin";
  version = "4.0-unstable-2025-09-24";

  src = ruleset-v4;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    clang_20
    llvmPackages_20.libclang
    llvmPackages_20.libllvm
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'clang-20' '${lib.getExe' clang_20 "clang"}' \
      --replace-fail 'clang++-20' '${lib.getExe' clang_20 "clang++"}'

      echo "install(TARGETS banana_clang DESTINATION lib)" | tee -a CMakeLists.txt
      echo "install(DIRECTORY include/ DESTINATION include)" | tee -a CMakeLists.txt
  '';

  meta = {
    description = "Clang plugin ruleset of banana";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
