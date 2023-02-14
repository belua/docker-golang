.PHONY: build push run

build:
    docker buildx bake

push:
    docker buildx bake --push

run:
    docker run --rm -it belua/golang:latest
