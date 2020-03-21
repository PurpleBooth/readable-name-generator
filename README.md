# Readable Name Generator

This generates a string using the [name generator from
docker](https://github.com/moby/moby/blob/master/pkg/namesgenerator/names-generator.go)
and prints it. That's all.

``` shell
$ readable-name-generator  
hungry_bhabha
```

## Using it

Download the [latest
release](https://github.com/PurpleBooth/readable-name-generator/releases)
and run it. There are no packages currently. I put mine on the path for
convenience. Or you could use docker.

### Docker

``` shell
docker run --rm -it purplebooth/readable-name-generator:latest
```

### Ubuntu

Download the latest release, make it executable, and then run it

``` shell
curl -Lo readable-name-generator https://github.com/PurpleBooth/readable-name-generator/releases/download/v2.0.1/readable-name-generator-ubuntu
chmod +x ./readable-name-generator
./readable-name-generator
```

### macOS

Download the latest release, make it executable, and then run it

``` shell
curl -Lo readable-name-generator https://github.com/PurpleBooth/readable-name-generator/releases/download/v2.0.1/readable-name-generator-macos
chmod +x ./readable-name-generator
./readable-name-generator
```

### Windows

I haven't tested this but if you have powershell you can use the curl
command.

``` shell
curl -Lo readable-name-generator.exe https://github.com/PurpleBooth/readable-name-generator/releases/download/v2.0.1/readable-name-generator-windows.exe
./readable-name-generator.exe
```

## Development

### Installing

You'll need to have [go installed](https://golang.org/doc/install). This
project uses go modules, so it'll have to be relatively recent.

Clone the repository then run

``` shell
make install
```

### Testing

To run the tests, run

``` shell
make test
```

### Automatic Code Formatting

To automatically tidy up the code in whatever way possible run

``` shell
make fmt
```

## License

It's [Apache License 2.0](LICENSE).

## Thanks

  - [Docker](https://www.docker.com/), they did all the work for this.
