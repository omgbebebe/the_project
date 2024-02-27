{
  inputs,
  cell
}:
let
  inherit (inputs) nixpkgs;
in {
  vectors = [
  {
    name = "vector-input";
    host = "127.0.0.1";
    port = 32030;
    config = "vector-input.toml";
  }
  {
    name = "vector-output";
    host = "127.0.0.1";
    port = 32031;
    config = "vector-output.toml";
  }
  ];
  nats = [
  ];
}
