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
  inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
in 
{
  kapitan = (mkPoetryApplication {
    projectDir = nixpkgs.fetchFromGitHub {
      owner = "kapicorp";
      repo = "kapitan";
      rev = "v0.33.1";
      sha256 = "sha256-A9m2T5fWo/PR/sYyuXj6b2s4YpSa0uxoGKa2wmri+Rg=";
    };
  }).dependencyEnv;
}
