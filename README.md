# Overview

PoC how to organize the project which contains various packages and provide a utilities to manage deployments to heterogeneous environments.

# Basics

You will need a working `nix` package manager (https://nixos.org/download) (use Single-user installation) with enabled `flake` subsystem (https://nixos.wiki/wiki/Flakes).
This repository organized as a `standard` repository (https://github.com/divnix/std)

## Run TUI to see what is available

```sh
$ nix run github:divnix/std
```

## Perform a Kapitan tasks

```sh
$ nix run github:divnix/std //kapitan/apps/kapitan:run compile
```

## Start a Vector instance

```sh
# you can start a std in a dedicated shell and use `std` command instead
$ nix shell github:divnix/std

$ std //vector/apps/vector:run -- --help
```

## Build a OCI conteiner

You can build a container and run it in docker.
```sh
$ std //vector/containers/vector:load
# ...bla-bla-bla...
Writing manifest to image destination
Done: docker-daemon:vector:lkbkcgyip4bnm4wg6n2yivi4zkr44vx4

$ docker run -it --rm vector:lkbkcgyip4bnm4wg6n2yivi4zkr44vx4
```
