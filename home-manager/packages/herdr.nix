{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.9.5";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-macos-aarch64";
      hash = "sha256-+3fCIyoFqANUITgsiUOS9BdOTjihjkivPdApAVfDp+I=";
    };
    x86_64-darwin = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-macos-x86_64";
      hash = "sha256-X7CpCOx/Z0Xj4kVziwa/rVbEY5HDkas8CVX76tAfE2k=";
    };
    x86_64-linux = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-FNnovItKngEY13wyJm921GHwm0A0LrI3UpYL2J9Zkp0=";
    };
    aarch64-linux = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-aarch64";
      hash = "sha256-F9dTby2lCFlSNoDvJ53/ysjkojX05G/o2mwuxEFBiXw=";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "herdr: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "herdr";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 $src $out/bin/herdr
    runHook postInstall
  '';

  meta = {
    description = "Terminal-based orchestrator/multiplexer for coding agents";
    homepage = "https://herdr.dev";
    license = lib.licenses.agpl3Plus;
    platforms = builtins.attrNames sources;
    mainProgram = "herdr";
  };
}
