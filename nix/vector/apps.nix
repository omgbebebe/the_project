{
  inputs,
  cell
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;
  package = nixpkgs.vector;

in {
  vector = std.lib.ops.mkOperable {
    inherit package;
    runtimeScript = ''
      exec ${package}/bin/vector "$@"
    '';

    meta = {
#      mainProgram = "vector";
      description = "A high-performance observability data pipeline";
    };
  };
}
