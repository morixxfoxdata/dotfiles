{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.7.4";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-macos-aarch64";
      hash = "sha256-JJkuFiXb3LGDVKWeKZ5LJjwxJACzE5bNwHzUbtV/JKc=";
    };
    x86_64-darwin = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-macos-x86_64";
      hash = "sha256-3fQwEzNS4XEkE9XYZbNKSFVG9GWIk/yJmGJX1lp1hag=";
    };
    x86_64-linux = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-vA/ALUulAPnKwjU6Q+Z/4DZ4Xsym61U3jgUPrDwQMFk=";
    };
    aarch64-linux = {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-linux-aarch64";
      hash = "sha256-VE4AAt5CgG0atkzN7zp+dBTyRxewtrAivJ5X0u79JqI=";
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
