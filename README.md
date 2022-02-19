# Readable Name Generator

Generate a readable name for throwaway infrastructure

``` shell,script(name="help")
readable-name-generator --help
```

``` shell,verify(script_name="help")
readable-name-generator 2.100.7

Generate a readable name for throwaway infrastructure

USAGE:
    readable-name-generator [OPTIONS]

OPTIONS:
    -c, --completion <completion_shell>
            Generate completion for your shell [possible values: bash, elvish, fish, powershell,
            zsh]

    -h, --help
            Print help information

    -i, --initial-seed <initial_seed>
            Use a known seed to generate the readable name for repeatability [env:
            READABLE_NAME_GENERATOR_INITIAL_SEED=]

    -s, --separator <separator>
            The separator to use [env: READABLE_NAME_GENERATOR_SEPARATOR=] [default: _]

    -V, --version
            Print version information
```

> **Note:** We are specifying a seed here, but it is optional. We
> include it here so the examples are replicable when we run them as
> part of our tests

``` shell,script(name="running")
readable-name-generator --initial-seed 1
```

``` shell,verify(script_name="running")
gregarious_pauli
```

``` shell,script(name="seperator")
readable-name-generator --initial-seed 1 --separator "###"
```

``` shell,verify(script_name="seperator")
gregarious###pauli
```

## Installing

Download the [latest
release](https://github.com/PurpleBooth/readable-name-generator/releases)
and run it. I install it with homebrew. Or you could use docker.

### Homebrew

``` shell,skip()
brew install PurpleBooth/repo/readable-name-generator
```

### Binaries

Binaries for Windows, Linux and MacOS are available on the [releases
page](https://github.com/PurpleBooth/readable-name-generator/releases/latest)

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
docker build -t "purplebooth/readable-name-generator:latest"
```

``` shell,skip()
docker run --rm -it purplebooth/readable-name-generator:latest -i 1
```

``` shell,skip()
gregarious_pauli
```

## License

[CC0 1.0 Universal](LICENSE).
