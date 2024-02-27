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

          { category = "operables"; package = cell.apps.vector-input; }
          { category = "operables"; package = cell.apps.vector-output; }
          { category = "operables"; package = inputs.cells.nats.apps.nats; }

          { category = "cli-dev"; package = inputs.cells.kapitan.packages.kapitan; }
#          { category = "cli-dev"; package = inputs.std.packages.x86_64-linux.std; }

        ] ++ (
          map (p: { category = "tools"; package = p; }) (with inputs.nixpkgs; [
            bat jq yq ripgrep fd entr expect
            tcpdump dig nettools procps
            tmux tab-rs
            neovim
            neofetch
            lua python311
          ])
        )
        ++ optionals nixpkgs.stdenv.isLinux [ ];
    };
  }
