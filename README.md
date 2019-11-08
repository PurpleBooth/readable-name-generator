# Moby Name Generator

This generates a string using the [name generator from docker](https://github.com/moby/moby/blob/master/pkg/namesgenerator/names-generator.go) and prints it. That's it.

```shell
moby-name-generator  
#=> hungry_bhabha
```

## Installing

You'll need to have [go installed](https://golang.org/doc/install). This project uses go modules, so it'll have to be relatively recent.

Clone the repository then run

```shell
make install
```

## Testing

To run the tests, run

```shell
make test
```

## Automatic Code Formatting

To automatically tidy up the code in whatever way possible run

```shell
make fmt
```

## License

It's [Apache License 2.0](LICENSE).

## Thanks

* [Docker](https://www.docker.com/), they did all the work for this.