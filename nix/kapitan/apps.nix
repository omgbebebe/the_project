{
  inputs,
  cell
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;
  package = cell.packages.kapitan;

in {
  kapitan = std.lib.ops.mkOperable {
    inherit package;
    runtimeScript = ''
      exec ${package}/bin/kapitan "$@"
    '';

    meta = {
#      mainProgram = "vector";
    };
  };
}
