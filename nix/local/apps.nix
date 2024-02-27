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
      exec echo ./nix/local/configs/vector-input.toml \
      | ${inputs.nixpkgs.entr}/bin/entr -r ${packages.vector}/bin/vector --config ./nix/local/configs/vector-input.toml
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
