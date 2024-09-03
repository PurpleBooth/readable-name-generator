FROM --platform=$BUILDPLATFORM tonistiigi/xx@sha256:0c6a569797744e45955f39d4f7538ac344bfb7ebf0a54006a0a4297b153ccf0f AS xx
ARG TARGETPLATFORM

FROM --platform=$BUILDPLATFORM rust:alpine@sha256:1f5aff501e02c1384ec61bb47f89e3eebf60e287e6ed5d1c598077afc82e83d5 AS builder
RUN apk add clang lld openssl-dev curl bash
# copy xx scripts to your build stage
COPY --from=xx / /
ARG TARGETPLATFORM

RUN xx-apk add --no-cache musl-dev zlib-dev zlib-static openssl-dev openssl-libs-static pkgconfig alpine-sdk

WORKDIR /app
RUN cargo new --lib readable-name-generator
WORKDIR /app/readable-name-generator
COPY Cargo.* ./
RUN xx-cargo build --release --target-dir ./build
COPY . ./
RUN xx-cargo build --release --target-dir ./build && \
    xx-verify --static "./build/$(xx-cargo --print-target-triple)/release/readable-name-generator" && \
    cp -v  "./build/$(xx-cargo --print-target-triple)/release/readable-name-generator" "./build/readable-name-generator"

FROM scratch
USER nonroot
COPY --from=builder /app/readable-name-generator/build/readable-name-generator .
ENTRYPOINT ["/readable-name-generator"]


