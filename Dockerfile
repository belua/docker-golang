ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG GO_VERSION

FROM golang:${GO_VERSION} as builder
RUN echo "Building on $BUILDPLATFORM for $TARGETPLATFORM!"

# Set the working directory to the GOPATH src folder
WORKDIR ${GOPATH:-/go}/src

# Install the Go tools in the builder stage
RUN go install github.com/cweill/gotests/...@latest \
    && go install github.com/fatih/gomodifytags@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install github.com/goreleaser/goreleaser@latest \
    && go install github.com/haya14busa/goplay/cmd/goplay@latest \
    && go install github.com/josharian/impl@latest \
    && go install github.com/kisielk/errcheck@latest \
    && go install github.com/temporalio/tctl/cmd/tctl@latest \
    && go install golang.org/x/tools/gopls@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install go.temporal.io/sdk/contrib/tools/workflowcheck@latest

# Use the base Go image as the final image
FROM golang:${GO_VERSION}

# Copy the installed Go tools from the builder stage
COPY --from=builder ${GOPATH:-/go}/bin/* ${GOPATH:-/go}/bin/

# Install necessary dependencies
RUN apt-get update \
  && apt-get install -y netcat-openbsd \
  && apt-get install -y neovim \
  && apt-get install -y less \
  && apt-get install -y zsh git

# Set up Oh My Zsh and Zsh
RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
ENV SHELL /bin/zsh
RUN chsh -s /bin/zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Set the default entrypoint for the container
ENTRYPOINT ["zsh"]
