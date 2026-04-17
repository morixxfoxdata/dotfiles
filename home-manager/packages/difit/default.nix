{ lib, buildNpmPackage, fetchzip }:

buildNpmPackage rec {
  pname = "difit";
  version = "4.0.3";

  src = fetchzip {
    url = "https://registry.npmjs.org/difit/-/difit-${version}.tgz";
    hash = "sha256-cab+kYADIUAblX4zBTI/ci/0qjKIUq1BkhUmMvyYssM=";
  };

  npmDepsHash = "sha256-Z8zG+/Vpbb+JZpBdFOrzPIDMh+vE4zCMWmupZcnvCSA=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmFlags = [ "--legacy-peer-deps" "--include=optional" "--ignore-scripts" ];
  dontNpmBuild = true;

  meta = {
    description = "A lightweight git diff viewer";
    homepage = "https://github.com/yoshiko-pg/difit";
    license = lib.licenses.mit;
    mainProgram = "difit";
  };
}
