{
  lib,
  stdenvNoCC,
  epiclang-src,
  clang_20,
  python3,
  banana-plugin,
}:
stdenvNoCC.mkDerivation {
  name = "epiclang";

  src = epiclang-src;

  dontBuild = true;

  postPatch = ''
    substituteInPlace epiclang.py \
      --replace-fail 'clang-20' '${lib.getExe clang_20}' \
      --replace-fail '/usr/lib/epiclang/plugins' '${lib.getLib banana-plugin}/lib'

    sed -i "1i #!${lib.getExe python3}" epiclang.py
  '';

  installPhase = ''
    runHook preInstall

    install -Dm577 epiclang.py $out/bin/epiclang

    runHook postInstall
  '';

  meta = {
    description = "Compiler wrapper used to compile Epitech C projects";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
