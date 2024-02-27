{
  inputs,
  cell
}: let
  inherit (inputs) nixpkgs std;

  l = nixpkgs.lib // builtins;
  package = cell.packages.nats;

in {
  nats = std.lib.ops.mkOperable {
    inherit package;
    runtimeScript = ''
      exec ${package}/bin/nats-server "$@"
    '';

    meta = {
#      mainProgram = "NATS";
      description = "";
    };
  };
}
