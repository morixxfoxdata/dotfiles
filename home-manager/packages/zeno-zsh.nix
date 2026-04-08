{ lib, stdenvNoCC, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "2e8fbecce0fc3692a5fcc9033ecca7ab35263e56";
    hash = "sha256-05+w1WP/SHKp97JTGsvO3csI123U7py+fVSKnAWiUNY=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "zeno-zsh";
  version = "unstable-2025-06-07";

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
