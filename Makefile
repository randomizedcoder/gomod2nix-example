all: container

go:
	nix run

container:
	nix build .#container

load_docker:
	docker load < result && docker run --rm example:0.1
	docker image ls | grep example