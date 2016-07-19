[![license](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://raw.githubusercontent.com/walle/tyda.d/master/LICENSE)

# tyda.d

CLI tool for searching website tyda.se.

**Only the simple format is implemented currently**

Requires the [tyda-api](https://github.com/walle/tyda-api) binary to be
installed.

If you have your `$GOPATH` set up, and `$GOPATH/bin` in you path
```
$ go get github.com/walle/tyda-api/...
```

## Installation

Uses the ´dub´ tool for building.

```shell
$ git clone https://github.com/walle/tyda.d.git
$ cd tyda.d
$ dub build # or dub -- parameters to run directly
```

You can also build it using `dmd`

```shell
$ dmd source/app.d
```

## Usage

```shell
$ tyda.d query
```

```shell
usage: tyda.d [--simple] [--languages LANGUAGES] QUERY

positional arguments:
  query

options:
  --simple, -s           Simple output
  --languages LANGUAGES, -l LANGUAGES
                         Languages to translate to (en fr de es la nb sv) [default: [en]]
  --help, -h             display this help and exit
```

## License

The code is under the MIT license. See [LICENSE](LICENSE) for more
information.
