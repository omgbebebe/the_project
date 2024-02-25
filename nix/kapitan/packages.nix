{
  inputs,
  cell
}: let
  inherit (inputs) std self cells;
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;
  poetry2nix = inputs.poetry2nix;
  system = inputs.nixpkgs.system;
  pkgs = inputs.nixpkgs.${system};
  inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication mkPoetryEnv defaultPoetryOverrides;
#  src = pkgs.stdenvNoCC.mkDerivation {
#    name = "kapitan";
#    src = nixpkgs.fetchFromGitHub {
#      owner = "kapicorp";
#      repo = "kapitan";
#      rev = "v0.33.1";
#      sha256 = "sha256-A9m2T5fWo/PR/sYyuXj6b2s4YpSa0uxoGKa2wmri+Rg=";
#    };
#
#    # copy all the output of mkPoetryEnv so that patching and wrapping of outputs works
#    phases = [ "unpackPhase" "patchPhase" "installPhase" ];
#    postUnpack = ''
#      sed -i '/poetry-version-plugin/d' source/pyproject.toml
#      sed -i '/gojsonnet/d' source/pyproject.toml
#    '';
#    installPhase = ''
#      mkdir $out
#      ls -la ./
#      cp -av ./ $out/
#    '';
#  };

  pypkgs-build-requirements = {
    libmagic = [ "setuptools" ];
    reclass = [ "setuptools" ];
    kadet = [ "poetry" ];
  };
  p2n-overrides = defaultPoetryOverrides.extend (self: super:
    let
      inherit (self.lib.asserts) assertMsg;
    in
      builtins.mapAttrs (package: build-requirements:
        (builtins.getAttr package super).overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ (builtins.map (pkg: if builtins.isString pkg then builtins.getAttr pkg super else pkg) build-requirements);
        })
      ) pypkgs-build-requirements);
         overrides = p2n-overrides.extend (
             self: super: let
               inherit (self.lib.asserts) assertMsg;
             in {
               rpds-py = super.rpds-py.overridePythonAttrs (old: {
                 cargoDeps =
                   assert assertMsg (old.version == "0.18.0")
                     "Expected ${old.version} to be version 0.18.0, remove this workaround in poetryOverrides.nix";
                   assert assertMsg (old.cargoDeps.hash == "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")
                     "Workaround no longer needed, remove it in poetryOverrides.nix";
                   self.pkgs.rustPlatform.fetchCargoTarball {
                     inherit (old) src;
                     name = "${old.pname}-${old.version}";
                     hash = "sha256-wd1teRDhjQWlKjFIahURj0iwcfkpyUvqIWXXscW7eek=";
                   };
               });
             }
         );
      
in 
{
  kapitan = (mkPoetryApplication {
    projectDir = nixpkgs.fetchFromGitHub {
      owner = "omgbebebe";
      repo = "kapitan";
      rev = "357ae45d8d7a7578814f82fb5b310042bc6f1006";
      sha256 = "sha256-NsPdb4Mr/a9IaZ5Gt/oHZt2ya7XqbQSCyYMMmou+SEI=";
    };
    overrides = overrides;
  });
#  }).dependencyEnv;
}
