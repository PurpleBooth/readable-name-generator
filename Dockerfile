FROM rust:latest@sha256:536c1a47d86bcfcd08b00dc234c44db1f809d4d82e86bc27fac1bf93c5da4d4a AS builder

## Update the system generally
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/app

## Build deps for git-mit
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN --mount=type=cache,target=/root/.cargo cargo clean
RUN --mount=type=cache,target=/root/.cargo cargo build --release

FROM rust:latest@sha256:536c1a47d86bcfcd08b00dc234c44db1f809d4d82e86bc27fac1bf93c5da4d4a
ENV DEBIAN_FRONTEND=noninteractive

## Update the system generally
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

### The Tool
COPY --from=builder \
    /root/app/target/release/readable-name-generator \
    /usr/local/bin/readable-name-generator

ENTRYPOINT ["/usr/local/bin/readable-name-generator"]
