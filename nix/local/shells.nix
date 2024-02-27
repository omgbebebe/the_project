{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs.lib) mapAttrs optionals;
  inherit (inputs.std) std;
  inherit (inputs.std.lib.dev) mkShell;
  inherit (cell) configs;
in
  mapAttrs (_: mkShell) rec {
    default = {...}: {
      name = "MindWM";
#      imports = [ std.devshellProfiles.default ];
      commands =
        [
          { category = "services"; package = inputs.cells.vector.packages.vector; }
          { category = "services"; package = inputs.cells.nats.packages.nats; }

          { category = "operables"; package = inputs.cells.vector.apps.vector; }
          { category = "operables"; package = inputs.cells.nats.apps.nats; }

          { category = "cli-dev"; package = inputs.cells.kapitan.packages.kapitan; }
#          { category = "cli-dev"; package = inputs.std.packages.x86_64-linux.std; }

        ] ++ (
          map (p: { category = "tools"; package = p; }) (with inputs.nixpkgs; [
            bat jq yq ripgrep fd
            tcpdump dig nettools procps
            tmux
            neovim
            neofetch
            lua python311
          ])
        )
        ++ optionals nixpkgs.stdenv.isLinux [
          {
            package = nixpkgs.golangci-lint;
            category = "cli-dev";
          }
        ];
    };
  }
