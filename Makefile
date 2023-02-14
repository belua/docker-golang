.PHONY: build push

build:
	docker buildx bake

push:
	docker buildx bake --push

default: build