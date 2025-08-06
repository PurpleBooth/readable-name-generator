ARG BUILDKIT_SBOM_SCAN_CONTEXT=true

# Download NFPM
FROM goreleaser/nfpm@sha256:929e1056ba69bf1da57791e851d210e9d6d4f528fede53a55bd43cf85674450c AS nfpm

FROM --platform=$BUILDPLATFORM rust:alpine@sha256:9dfaae478ecd298b6b5a039e1f2cc4fc040fc818a2de9aa78fa714dea036574d AS base
ARG BUILDKIT_SBOM_SCAN_STAGE=true

RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

# Use bash rather than sh
RUN apk add --no-cache bash
SHELL ["/usr/bin/env", "bash", "-c"]

# Install tools required for cross-compilation and building
RUN apk add --no-cache \
    alpine-sdk \
    bash \
    binutils \
    bzip2 \
    ca-certificates \
    clang \
    curl \
    gcc \
    git \
    libc++-dev \
    libc-dev \
    mingw-w64-binutils \
    musl-dev \
    musl-utils \
    openssl-dev  \
    unzip \
    xz \
    zig

# renovate: datasource=crate depName=cargo-binstall
ARG CARGO_BINSTALL_VERSION=1.14.1
RUN wget https://github.com/cargo-bins/cargo-binstall/releases/download/v${CARGO_BINSTALL_VERSION}/cargo-binstall-x86_64-unknown-linux-musl.full.tgz -O - | \
    tar -xz && \
    mv cargo-binstall /usr/local/bin/
ENV PATH=/root/.cargo/bin:$PATH

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.47.1
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

RUN addgroup -S nonroot && \
    adduser -S -G nonroot nonroot && \
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
