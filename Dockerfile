ARG BUILDKIT_SBOM_SCAN_CONTEXT=true

# Download NFPM
FROM goreleaser/nfpm@sha256:90720c4efb125ff8a2d15da923a4968b2360f39e164bf97dac78127d394f39ad AS nfpm

# Use Debian bookworm (stable) as base instead of Alpine
FROM --platform=$BUILDPLATFORM ubuntu@sha256:728785b59223d755e3e5c5af178fab1be7031f3522c5ccd7a0b32b80d8248123 AS base
ARG BUILDKIT_SBOM_SCAN_STAGE=true

# Update system packages
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Use bash as default shell
SHELL ["/bin/bash", "-c"]

# Install essential cross-compilation tools and development packages
RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    mingw-w64 \
    curl \
    git \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --profile complete --component rustfmt,clippy --target x86_64-apple-darwin,aarch64-apple-darwin,aarch64-pc-windows-gnullvm,x86_64-pc-windows-gnu,x86_64-unknown-linux-gnu,aarch64-unknown-linux-gnu,x86_64-unknown-linux-musl,aarch64-unknown-linux-musl

# Install Zig
# renovate: datasource=github-releases depName=ziglang/zig
ARG ZIG_VERSION=0.15.1
RUN curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz | \
    tar -xJ -C /opt && \
    ln -s /opt/zig-x86_64-linux-${ZIG_VERSION}/zig /usr/local/bin/zig && \
    zig version

# renovate: datasource=crate depName=cargo-binstall
ARG CARGO_BINSTALL_VERSION=1.14.1
RUN wget https://github.com/cargo-bins/cargo-binstall/releases/download/v${CARGO_BINSTALL_VERSION}/cargo-binstall-x86_64-unknown-linux-musl.full.tgz -O - | \
    tar -xz && \
    mv cargo-binstall /usr/local/bin/
ENV PATH=/root/.cargo/bin:$PATH

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.47.2
ARG YQ_BINARY=yq_linux_amd64
RUN wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/${YQ_BINARY}.tar.gz -O - | \
    tar -xz && mv ${YQ_BINARY} /usr/local/bin/yq

# renovate: datasource=github-releases depName=specdown/specdown
ARG SPECDOWN_VERSION=1.2.112
RUN TEMP_SRC="$(mktemp -d)" && \
    git clone https://github.com/specdown/specdown.git "$TEMP_SRC" && \
    cd "$TEMP_SRC" && \
    git switch --detach "v${SPECDOWN_VERSION}" && \
    cargo build --release && \
    cp -v target/release/specdown /usr/local/bin/specdown && \
    cd / && \
    rm -rf "$TEMP_SRC" && \
    specdown --version

# renovate: datasource=crate depName=cargo-audit
ARG CARGO_AUDIT_VERSION=0.21.2
RUN cargo binstall cargo-audit --version ${CARGO_AUDIT_VERSION} --locked

# renovate: datasource=crate depName=cargo-zigbuild
ARG CARGO_ZIGBUILD_VERSION=0.20.1
RUN cargo binstall cargo-zigbuild --version ${CARGO_ZIGBUILD_VERSION} --locked

# renovate: datasource=github-releases depName=konoui/lipo
ARG LIPO_VERSION=0.10.0
RUN curl -L -o /tmp/lipo https://github.com/konoui/lipo/releases/download/v${LIPO_VERSION}/lipo_Linux_amd64 && \
    chmod +x /tmp/lipo && \
    mv /tmp/lipo /usr/local/bin/

RUN rustup component add rustfmt clippy

RUN addgroup --system nonroot && \
    adduser --system --ingroup nonroot nonroot && \
    mkdir -p /app /home/nonroot/.cargo/bin/ && \
    chown -R nonroot:nonroot /app /home/nonroot

COPY build/cross-platform-build /usr/local/bin/cross-platform-build

WORKDIR /app

ARG TARGETPLATFORM
ENV TARGETPLATFORM=$TARGETPLATFORM

ARG TARGETOS
ENV TARGETOS=$TARGETOS

ARG TARGETARCH
ENV TARGETARCH=$TARGETARCH

COPY Cargo.* .
RUN cargo fetch

COPY --from=nfpm /usr/bin/nfpm /usr/bin/nfpm
COPY . .
