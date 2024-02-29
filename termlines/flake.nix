{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
      in
      {
        packages = {
          myapp = mkPoetryApplication {
            projectDir = self;
#overrides = [ poetry2nix.defaultPoetryOverrides
            overrides = poetry2nix.overrides.withDefaults (self: super: { foo = null; });
#            [ poetry2nix.overrides.withDefaults
#              (self: super: {
#                pyte = super.faker.overridePythonAttrs(old: {
#                  buildInputs = old.buildInputs ++ [
#                    self.pytestrunner
#                  ];
#                });
#              })
#            ];
          };
          default = self.packages.${system}.myapp;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.myapp ];
          packages = [ pkgs.poetry ];
        };
      });
}
