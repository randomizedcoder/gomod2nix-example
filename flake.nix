#
# flake.nix
#
# https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake.html
#
{
  description = "A basic gomod2nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix.url = "github:nix-community/gomod2nix";

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ gomod2nix.overlays.default ];
          };

        in
        rec {
          packages.default = pkgs.callPackage ./. { };
          packages.container = pkgs.callPackage ./container.nix { package = packages.default; };
          devShells.default = import ./shell.nix { inherit pkgs; };
        })
    );
}