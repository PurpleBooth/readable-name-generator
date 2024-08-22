FROM rust:1.80 AS builder
ARG TARGETPLATFORM
USER 1000
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then  \
    rustup target add x86_64-unknown-linux-musl;  \
    elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then  \
    rustup target add armv7-unknown-linux-musleabihf;  \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then  \
    rustup target add aarch64-unknown-linux-musl;  \
    else exit 1;  \
    fi

WORKDIR /app/readable-name-generator
COPY . ./

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then  \
    cargo build --target=x86_64-unknown-linux-musl --release ;  \
    elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then  \
    cargo build --target=armv7-unknown-linux-musleabihf --release ;  \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then  \
    cargo build --target=aarch64-unknown-linux-musl --release ;  \
    else exit 1;  \
    fi

# Bundle Stage
FROM scratch
COPY --from=builder /app/readable-name-generator/target/*/release/readable-name-generator .
RUN ["./readable-name-generator"]
USER 1000
ENTRYPOINT ["./readable-name-generator"]
