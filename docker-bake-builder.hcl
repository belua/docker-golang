variable "DOCKER_ORG" {
  default = "belua"
}

variable "DOCKER_REGISTRY" {
  default = "docker.io"
}

variable "GO_VERSION" {
  default = "1.20.1"
}

target "default" {
  dockerfile="Dockerfile-builder"
  platforms = [ "linux/amd64", "linux/arm64"]
  push = true
  registry = "${DOCKER_REGISTRY}"
  tags = [ 
    tag("golang-builder:latest"),
    tag("golang-builder:${GO_VERSION}")
  ]
  args = {
    GO_VERSION = "${GO_VERSION}"
  }
}

function "tag" {
  params = [value]
  result = "${DOCKER_ORG}/${value}"
}
