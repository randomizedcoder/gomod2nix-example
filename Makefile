all: container

container:
	nix build .#container

go:
	nix run

load_docker:
	docker load < result
	docker run --rm example:0.1
	docker image ls | grep example

check:
	nix flake check

lock:
	nix flake lock

# Manual instructions
# nix-shell
# gomod2nix
# nix build .#container
# docker load < result
# docker run --rm example:0.1
# docker image ls | grep example