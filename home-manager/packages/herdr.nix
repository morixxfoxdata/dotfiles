{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.7.5";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-macos-aarch64";
      hash = "sha256-NzUFRrABJVWUO5Lq+WJmXeTiZDlbrrRCJ7gBXo/1sNY=";
    };
    x86_64-darwin = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-macos-x86_64";
      hash = "sha256-P+UMSmPcgQIwaxMiF4Yo3bNlXNOuVteE8JQVNAjWnmI=";
    };
    x86_64-linux = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-PcgyiAc+TC08Z5ow576XvMqRQcb9F9u7khkULpXFklM=";
    };
    aarch64-linux = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-linux-aarch64";
      hash = "sha256-MudjoUmaa2lLHXCOTwYrdDvh2p80/PpNIS1ttv4JqLk=";
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
