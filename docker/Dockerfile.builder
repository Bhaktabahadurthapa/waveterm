FROM ubuntu:24.04

# Build arguments
ARG GO_VERSION=1.23
ARG NODE_VERSION=22
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic tools
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    python3 \
    python3-pip \
    # For Wave Terminal build requirements
    zip \
    unzip \
    # For cross-compilation
    gcc-multilib \
    g++-multilib \
    # For packaging
    rpm \
    libarchive-tools \
    libopenjp2-tools \
    squashfs-tools \
    binutils \
    # For snaps
    snapd \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# Install Zig compiler for static linking
RUN wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz \
    && tar -xf zig-linux-x86_64-0.13.0.tar.xz \
    && mv zig-linux-x86_64-0.13.0 /usr/local/zig \
    && ln -s /usr/local/zig/zig /usr/local/bin/zig \
    && rm zig-linux-x86_64-0.13.0.tar.xz

# Install Go
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs

# Install Task
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Install FPM
RUN gem install fpm

# Install Snapcraft
RUN snap install snapcraft --classic || true
RUN snap install lxd || true

# Create builder user
RUN useradd -m -s /bin/bash builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
    mkdir -p /home/builder/.config

# Switch to builder user
USER builder
WORKDIR /home/builder

# Set up environment variables
ENV PATH="/usr/local/go/bin:/usr/local/zig:${PATH}"
ENV GOPATH="/home/builder/go"
ENV GOROOT="/usr/local/go"
ENV PATH="${GOPATH}/bin:${PATH}"
ENV USE_SYSTEM_FPM=1

# Enable Corepack for Yarn
RUN corepack enable

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Set up git configuration
RUN git config --global user.email "builder@waveterm.dev" && \
    git config --global user.name "Wave Terminal Builder"

# Copy build scripts
COPY docker/build-entrypoint.sh /usr/local/bin/build-entrypoint.sh
RUN sudo chmod +x /usr/local/bin/build-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/build-entrypoint.sh"]
CMD ["task", "package"]