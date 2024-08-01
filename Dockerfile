FROM rust:latest@sha256:fcbb950e8fa0de7f8ada015ea78e97ad09fcc4120bf23485664e418e0ec5087b AS builder

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

FROM rust:latest@sha256:fcbb950e8fa0de7f8ada015ea78e97ad09fcc4120bf23485664e418e0ec5087b
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
