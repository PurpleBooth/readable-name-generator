VERSION --global-cache 0.7

xx:
  FROM tonistiigi/xx
  SAVE ARTIFACT /*

install:
  FROM rust:1.80
  RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y clang lld
  COPY +xx/ /
  WORKDIR /app
  RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  RUN cargo binstall --no-confirm cargo-audit
  RUN cargo binstall --no-confirm cargo-sweep
  RUN cargo binstall --no-confirm cargo-edit
  RUN cargo binstall --no-confirm --locked cocogitto
  RUN rustup toolchain install nightly --component clippy,rustfmt
  RUN rustup toolchain install stable --component clippy,rustfmt
  RUN rustup target add x86_64-unknown-linux-gnu
  RUN rustup target add aarch64-unknown-linux-gnu
  RUN rustup target add x86_64-unknown-linux-musl
  RUN rustup target add aarch64-unknown-linux-musl
  RUN rustup target add x86_64-pc-windows-gnu
  RUN rustup target add x86_64-apple-darwin
  RUN rustup target add aarch64-apple-darwin

source:
  FROM +install
  CACHE target
  RUN cargo new --bin readable-name-generator
  WORKDIR /app/readable-name-generator
  COPY --keep-ts Cargo.toml Cargo.lock ./
  RUN cargo fetch
  COPY --keep-ts --dir src *.md  ./

# build builds with the Cargo release profile
build:
  FROM +source
  ARG tripple="x86_64-unknown-linux-gnu"
  CACHE target/$tripple
  RUN rustup target add "$tripple" 
  RUN xx-cargo build --release --target="$tripple"
  RUN xx-verify "./target/$tripple/release/readable-name-generator"
  SAVE ARTIFACT "./target/$tripple/release/readable-name-generator" target AS LOCAL artifacts/readable-name-generator-$tripple

# all runs all other targets in parallel
all:
  FROM +source
  FOR tripple IN x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-pc-windows-gnu x86_64-apple-darwin aarch64-apple-darwin
    BUILD +build --tripple=$tripple
  END
