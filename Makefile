all: container

go:
	nix run

container:
	nix build .#container