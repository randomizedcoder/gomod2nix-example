{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
}:

# https://nixos.wiki/wiki/Go
# https://nixos.wiki/wiki/Go#Compile_go_program_with_static_compile_flag_.28take_2.29
buildGoApplication {
  pname = "example";
  version = "0.1";

  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;

  CGO_ENABLED = 0;
  #nativeBuildInputs = [musl];
  ldflags = [
  #  # https://words.filippo.io/shrink-your-go-binaries-with-this-one-weird-trick/
    "-s -w"
  #  "-X main.commit=${COMMIT} -X main.date=${DATE} -X main.version=${VERSION}"
  ];

  # not sure why this doesn't work
  #meta = with lib; {
  #  description = "gomod2nix-example flake";
  #  homepage = "https://github.com/randomizedcoder/gomod2nix-example";
  #  license = licenses.mit;
  #  #maintainers = with maintainers; [ fixme ];
  #};
}
