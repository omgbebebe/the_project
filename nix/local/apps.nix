{
  inputs,
  cell
}:
let
  packages = {
    vector = inputs.nixpkgs.vector;
    tmuxinator = inputs.nixpkgs.tmuxinator;
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
  tmuxinator-infra-minimal = inputs.std.lib.ops.mkOperable {
    package = packages.tmuxinator.overrideAttrs (f: p: { name = p.name + "-infra-minimal";});
    runtimeScript = ''
      ${packages.tmuxinator}/bin/tmuxinator start -p ./nix/local/configs/tmuxinator-infra-minimal.yml
    '';
    meta.description = "Launch a minimal infra service set";
  };
}
