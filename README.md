# Moby Name Generator

This generates a string using the [name generator from docker](https://github.com/moby/moby/blob/master/pkg/namesgenerator/names-generator.go) and prints it. That's it.

```shell
moby-name-generator  
#=> hungry_bhabha
```

## Installing

Download the [latest release](https://github.com/PurpleBooth/moby-name-generator/releases) and run it. There are no packages currently. I put mine on the path for convenience. 

### Ubuntu

Download the latest release, make it executable, and then run it

```shell
curl -Lo moby-name-generator https://github.com/PurpleBooth/moby-name-generator/releases/download/v1.0.0/moby-name-generator-ubuntu
chmod +x ./moby-name-generator
./moby-name-generator
```

### macOS

Download the latest release, make it executable, and then run it

```shell
curl -Lo moby-name-generator https://github.com/PurpleBooth/moby-name-generator/releases/download/v1.0.0/moby-name-generator-macos
chmod +x ./moby-name-generator
./moby-name-generator
```

### Windows

I haven't tested this but if you have powershell you can use the curl command.

```shell
curl -Lo moby-name-generator.exe https://github.com/PurpleBooth/moby-name-generator/releases/download/v1.0.0/moby-name-generator-windows.exe
./moby-name-generator.exe
```

## Development

### Installing

You'll need to have [go installed](https://golang.org/doc/install). This project uses go modules, so it'll have to be relatively recent.

Clone the repository then run

```shell
make install
```

### Testing

To run the tests, run

```shell
make test
```

### Automatic Code Formatting

To automatically tidy up the code in whatever way possible run

```shell
make fmt
```

## License

It's [Apache License 2.0](LICENSE).

## Thanks

* [Docker](https://www.docker.com/), they did all the work for this.