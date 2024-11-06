#
# flake.nix
#
# https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake.html
#
{
  description = "A basic gomod2nix flake";

  # Release 23.11 (“Tapir”, 2023.11/29)
  # https://nixos.org/manual/nixos/stable/release-notes.html
  # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs/nixos-23.11";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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