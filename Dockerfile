ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG GO_VERSION

FROM belua/golang-builder:${GO_VERSION} as builder
RUN echo "Building on $BUILDPLATFORM for $TARGETPLATFORM!"

# Set the working directory to the GOPATH src folder
WORKDIR ${GOPATH:-/go}/src

# Install the Go tools in the builder stage
# RUN go install github.com/cweill/gotests/...@latest && \
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install github.com/goreleaser/goreleaser@latest
RUN go install github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install github.com/josharian/impl@latest
RUN go install github.com/kisielk/errcheck@latest
RUN go install github.com/ramya-rao-a/go-outline@latest
RUN go install github.com/spf13/cobra-cli@latest
RUN go install golang.org/x/tools/gopls@latest
RUN go install go.temporal.io/sdk/contrib/tools/workflowcheck@latest
RUN go install honnef.co/go/tools/cmd/staticcheck@latest
RUN go install github.com/bufbuild/buf/cmd/buf@latest
 
# Use the base Go image as the final image \
FROM belua/golang-builder:${GO_VERSION}

# Copy the installed Go tools from the builder stage
COPY --from=builder ${GOPATH:-/go}/bin/* ${GOPATH:-/go}/bin/

# Install necessary dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apt-transport-https && \
    apt-get install -y ca-certificates && \
    apt-get install -y curl && \
    apt-get install -y git && \
    apt-get install -y gnupg && \
    apt-get install -y iputils-ping && \
    apt-get install -y less && \
    apt-get install -y make && \
    apt-get install -y lsb-release && \
    apt-get install -y neovim && \
    apt-get install -y netcat-openbsd && \
    apt-get install -y wget && \
    apt-get install -y zsh && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/* && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get install -y vault packer && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up Oh My Zsh and Zsh
RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    chsh -s /bin/zsh && \
    sed -i \
      's/plugins=(git)/plugins=(docker gcloud gh git gnu-utils golang vscode)/g' \
      ~/.oh-my-zsh/templates/zshrc.zsh-template && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    echo "export EDITOR=/usr/bin/nvim" >> ~/.zshrc

ENV SHELL /bin/zsh

# Set the default entrypoint for the container
ENTRYPOINT ["zsh"]
