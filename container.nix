{ pkgs, package }:

# https://spacekookie.de/blog/ocitools-in-nixos/
# https://nixos.org/manual/nixpkgs/stable/#ssec-pkgs-dockerTools-buildImage

pkgs.dockerTools.buildImage {
  name = "example";
  tag = "0.1";
  created = "now";
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ package ];
    pathsToLink = [ "/bin" ];
  };
  config.Cmd = [ "${package}/bin/gomod2nix-example" ];
}