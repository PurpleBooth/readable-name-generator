
target "bins" {
  name = "bins-${join("-", split("/", item.TARGETPLAFORM))}"
  dockerfile = "Dockerfile"
  args = {
    TARGETPLAFORM = "${item.TARGETPLAFORM}"
  }
  output = ["type=local,dest=packs/${item.TARGETPLAFORM}"]

  matrix = {
    item = [
      {
        TARGETPLAFORM = "linux/amd64"
      },
      {
        TARGETPLAFORM = "linux/arm64"
      },
      {
        TARGETPLAFORM = "alpine/amd64"
      },
      {
        TARGETPLAFORM = "alpine/arm64"
      },
      {
        TARGETPLAFORM = "darwin/amd64"
      },
      {
        TARGETPLAFORM = "darwin/arm64"
      },
      {
        TARGETPLAFORM = "windows/amd64"
      },
      {
        TARGETPLAFORM = "windows/arm64"
      }
    ]
  }
}


target "base" {
  dockerfile_inline = <<EOF
FROM --platform=$BUILDPLATFORM alpine AS builder
RUN addgroup -g 568 nonroot
RUN adduser -u 568 -G nonroot -D nonroot
FROM baseapp
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
EOF
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
  tags = ["ghcr.io/purplebooth/readable-name-generator"]
  platform = ["alpine/amd64", "alpine/arm64"]
}


target "docker" {
  contexts = {
      baseapp = "target:base"
  }
  dockerfile_inline = <<EOF
FROM --platform=$BUILDPLATFORM alpine AS builder
RUN addgroup -g 568 nonroot
RUN adduser -u 568 -G nonroot -D nonroot
FROM baseapp
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
RUN ["/readable-name-generator", "--version"]
EOF
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
  tags = ["ghcr.io/purplebooth/readable-name-generator:edge"]
  platform = ["alpine/amd64", "alpine/arm64"]
}

group "default" {
  targets = ["bins", "docker"]
}
