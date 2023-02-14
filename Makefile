.PHONY: build push run

build:
	docker buildx bake

push:
	docker buildx bake --push

run:
	docker run --rm -it -v "$(PWD)":/app -w /app belua/golang:latest 