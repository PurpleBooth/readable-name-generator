# This help screen
show-help:
        just --list

# Test it was built ok
test:
        RUST_BACKTRACE=1 cargo test

# Test the markdown in the docs directory
specdown: build
        specdown run --temporary-workspace-dir --add-path "{{justfile_directory()}}/target/release" ./README.md

# Run a smoke test and see if the app runs
smoke-test: build
        cargo run -- -h

# Build release version
build:
        cargo build --release

# Lint it
lint:
        cargo fmt --all -- --check
        cargo clippy --all-features
        cargo check
        cargo audit

# Format what can be formatted
fmt:
        cargo fix --allow-dirty
        cargo clippy --allow-dirty --fix --all-features
        cargo fmt --all

# Clean the build directory
clean:
        cargo clean
