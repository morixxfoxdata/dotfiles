{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.9.1";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-macos-aarch64";
      hash = "sha256-X8en5636ylb6gKqJ3LAlaTNXJo2rgoW5zi0IojE8id4=";
    };
    x86_64-darwin = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-macos-x86_64";
      hash = "sha256-BTvgY5k1/lSrXvvbRmUQVOT2p1OltDFTyIvWkSvOHpQ=";
    };
    x86_64-linux = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-KgL+0WvrZR7wBuHUPwSPZSyk3FitBTzS1ERQVj1cVLc=";
    };
    aarch64-linux = {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-aarch64";
      hash = "sha256-9Mz03nRfLLmjmpg+m6NwPa1Q7CpY3qgwJs6rchu9jZ4=";
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
