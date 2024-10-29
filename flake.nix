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
          packages.container = pkgs.dockerTools.buildImage {
            name = "example";
            tag = "0.1";
            created = "now";
            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              paths = [ packages.default ];
              pathsToLink = [ "/bin" ];
            };
            config.Cmd = [ "${packages.default}/bin/example" ];
          };
          devShells.default = import ./shell.nix { inherit pkgs; };
        })
    );
}