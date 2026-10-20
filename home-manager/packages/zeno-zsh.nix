{ lib, stdenvNoCC, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "f6ed8fc16cc32dc110fa4f77a50386624067fbe2";
    hash = "sha256-KmtmmGzWGBLslro3fkA0qx9YNV5lwlrgRzz7tiKSwvA=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "zeno-zsh";
  version = "unstable-2026-10-03";

  inherit src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/zeno
    find . -mindepth 1 -maxdepth 1 \
      ! -name node_modules \
      ! -name test \
      -exec cp -r {} $out/share/zeno/ \;
    find $out/share/zeno -type f \
      -exec grep -l 'node-modules-dir=auto' {} \; \
      | while read f; do
        substituteInPlace "$f" --replace-fail '--node-modules-dir=auto' ""
      done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zsh fuzzy completion and utility plugin powered by Deno";
    homepage = "https://github.com/yuki-yano/zeno.zsh";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
