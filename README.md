# Readable Name Generator

Generate a readable name for throwaway infrastructure

## Usage

### Basic Usage

``` shell,script(name="random_name")
readable-name-generator
```

``` shell,skip()
capable_munson
```

### Reproducing names

``` shell,script(name="running")
readable-name-generator --initial-seed 1
```

``` shell,verify(script_name="running")
gregarious_pauli
```

### Changing the separator

``` shell,script(name="seperator")
readable-name-generator --initial-seed 1 --separator "###"
```

``` shell,verify(script_name="seperator")
gregarious###pauli
```

### Full usage

``` shell,script(name="help")
readable-name-generator --help
```

``` shell,verify(script_name="help")
Generate a readable name for throwaway infrastructure

Usage: readable-name-generator [OPTIONS]

Options:
  -s, --separator <SEPARATOR>
          The separator to use [env: READABLE_NAME_GENERATOR_SEPARATOR=] [default: _]
  -i, --initial-seed <INITIAL_SEED>
          Use a known seed to generate the readable name for repeatability [env:
          READABLE_NAME_GENERATOR_INITIAL_SEED=]
  -c, --completion-shell <COMPLETION_SHELL>
          Generate completion for your shell [env: COMPLETION_SHELL=] [possible values: bash,
          elvish, fish, powershell, zsh]
  -h, --help
          Print help
  -V, --version
          Print version
```

### Docker

We also have a docker image

``` shell,skip()
docker run --rm -it ghcr.io/purplebooth/readable-name-generator:latest -i 1
```

``` shell,skip()
gregarious_pauli
```

## Installing

Download the [latest
release](https://codeberg.org/PurpleBooth/readable-name-generator/releases)
and run it. I install it with homebrew. Or you could use docker.

### Binaries

Binaries for Windows, Linux and MacOS are available on the [releases
page](https://codeberg.org/PurpleBooth/readable-name-generator/releases/latest)

### Packages

Packages are available for various platforms, including Debian, Arch Linux, RPM-based distributions, Alpine, and Docker.

You can access them on the [packages page](https://codeberg.org/PurpleBooth/readable-name-generator/packages).

Additionally, a Homebrew repository is provided:

``` shell,skip()
brew install PurpleBooth/repo/readable-name-generator
```

## Development

### Testing

To run the tests, run

``` shell,skip()
just test
```

To run the end-to-end tests, run

``` shell,skip()
just specdown
```

### Automatic Code Formatting

To automatically tidy up the code in whatever way possible run

``` shell,skip()
just fmt
```

### Building docker

We have a docker container

``` shell,skip()
docker build -t "ghcr.io/purplebooth/readable-name-generator:latest"
docker run --rm -it ghcr.io/purplebooth/readable-name-generator:latest -i 1
```

``` shell,skip()
gregarious_pauli
```

## License

[CC0 1.0 Universal](LICENSE.md).
