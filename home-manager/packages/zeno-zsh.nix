{ lib, stdenvNoCC, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "490121876701f472e7596b606048a7e1b73b5b03";
    hash = "sha256-sCZjmx13YjdUVJeG/OZ/O5hx34k5mo1enDS7smUv1K8=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "zeno-zsh";
  version = "unstable-2026-08-31";

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
