{
  outputs = inputs @ {self, std, ...}:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (installables "packages")
        (runnables "apps")
        (containers "containers")
        (devshells "shells" {ci.build = true;})
      ];
    } {
      packages = std.harvest self [
        ["nats" "packages"]
        ["vector" "packages"]
      ];
      devShells = std.harvest self ["local" "shells"];
    };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/23.11";

  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.devshell.url = "github:numtide/devshell";
    std.inputs.n2c.follows = "n2c";
    std.inputs.nixago.follows = "nixago";
    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.follows = "";
    poetry2nix.url = "github:/nix-community/poetry2nix";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
