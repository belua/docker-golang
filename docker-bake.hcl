variable "DOCKER_ORG" {
  default = "belua"
}

variable "DOCKER_REGISTRY" {
  default = "docker.io"
}

variable "GO_VERSION" {
  default = "1.20.0"
}

target "default" {
  dockerfile="Dockerfile"
  platforms = [ "linux/amd64", "linux/arm64"]
  push = true
  registry = "${DOCKER_REGISTRY}"
  tags = [ 
    tag("golang:latest"),
    tag("golang:${GO_VERSION}")
  ]
  args = {
    GO_VERSION = "${GO_VERSION}"
  }
}

function "tag" {
  params = [value]
  result = "${DOCKER_ORG}/${value}"
}