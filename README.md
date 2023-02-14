# Golang Development Environment

This Docker image provides a Go development environment with tools for testing, debugging and code analysis. The image is based on the latest `golang` image from Docker hub.

## Tools included

- gotests: a tool for generating Go tests from source code.
- gomodifytags: a tool for modifying Go struct field tags.
- impl: a tool for generating method stubs for interfaces.
- goplay: an online playground for Go.
- gopls: the Go language server.
- dlv: a debugger for Go.
- staticcheck: a Go linter with an emphasis on preserving code compatibility.
- workflowcheck: a tool for checking the correctness of Temporal workflows written in Go.
- tctl: a command-line tool that you can use to interact with a Temporal Cluster.

## Building and pushing the image

The included `Makefile` provides a `build` target for building the image and a push target for pushing the image to a registry.

To build the image, simply run:

```bash
make build
```

## Pushing the Image

The Docker image can be pushed to a registry using the provided Makefile. The `push` target pushes the image to a registry:

```bash
make push
```

## Usage

You can use the image in your projects by specifying it as the base image in your Dockerfile:

```Docker
FROM belua/golang:latest
```
