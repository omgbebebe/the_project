{
  inputs,
  cell
}:
let
  packages = {
    vector = inputs.nixpkgs.vector;
  };
in {
  vector-input = inputs.std.lib.ops.mkOperable {
    package = packages.vector.overrideAttrs (f: p: { pname = p.pname + "-input";});
    runtimeScript = ''
      exec ${packages.vector}/bin/vector --config vector-input.toml
    '';

    meta.description = "A vector instance to parse an user input";
  };
  vector-output = inputs.std.lib.ops.mkOperable {
    package = packages.vector.overrideAttrs (f: p: { pname = p.pname + "-output";});
    runtimeScript = ''
      exec ${packages.vector}/bin/vector --config vector-output.toml
    '';

    meta = {
      description = "A vector instance to parse a std{out,err} from programms";
    };
  };
}
