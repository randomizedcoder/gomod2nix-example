{ pkgs, package }:

pkgs.dockerTools.buildImage {
  name = "example";
  tag = "0.1";
  created = "now";
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ package ];
    pathsToLink = [ "/bin" ];
  };
  config.Cmd = [ "${package}/bin/example" ];
}