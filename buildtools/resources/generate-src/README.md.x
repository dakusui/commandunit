cat <<'END'
<!--- DO NOT EDIT: THIS FILE IS GENERATED AUTOMATICALLY -->

# The `commandunit` testing framework.

The `commandunit` is a testing framework intended to verrify your command line
tools. You can define your tests in JSON or YAML formats. It is also powered
by `jq-front` processor, with which you can write your JSON files using
inheritance and references.

## Usage

Runs tests.

```bash
Usage: commandunit [OPTION]... [SUBCOMMAND]...
```

### Sub-commands:

* `preprocess`:
  Preprocesses test definition files (yaml++, yaml, and json++) and convert them
  into "executable JSON test" files
* `run`:
  Runs tests under a directory specified by `--test-workdir` and writes a report
  file: `testreport.json` under a directory specified by `--test-reportdir`.
* `report`:
  Reads a file `testreport.json` under directory specified by `--test-reportdir`
  and renders a report file (`testreport.adoc`) under the same directory.

If no sub-command is given, it will be interpreted as a sequence of `preprocess`
, `run`, and `report`.

### Options:

* `-h`, `--help`: show this help
* `-p`, `--parallel`: execute the tests in parallel
* `-f`, `--filter`: filter tests with the specified regular expression(default:
  {regexany})
* `--configdir`: directory to store config files (default: current
  {directory/.commandunit})
* `--test-srcdir`: write test reports under the specified directory (default:
  current directory)
* `--test-workdir`: write test reports under the specified directory (default:
  value for `--test-srcdir`)
* `--test-reportdir`: write test reports under the specified directory (default:
  value for `--test-workdir`)

### Examples:

`commandunit`
Run tests found under current directory in sequential mode.

`commandunit --srcdir=DIR`
Run tests found under DIR in sequential mode.

`commandunit --srcdir=DIR -p`
Run tests found under DIR in parallel mode.

## Installation

Although it is possible to install `commandunit` scripts in your directory
struture, it is highly adviced to use Docker to use `commandrunner` to avoid
compatibility issues. Have the following bash function definition in
your `~/.bashrc`.

```bash
END

bash -eu -E ""$(dirname "${0}")"/src/site/adoc/resources/examples/function_definition.rc.x"

cat <<'END'
```

Or run the following one-liner.

```bash
END

cat "$(dirname "$(dirname "$(dirname "$(dirname "${0}")")")")/src/site/adoc/resources/examples/oneline_installer.sh"

cat <<'END'
```

If you are on `macOS`, make sure `~/.bashrc` is read by `~/.bash_profile`.

## Building commandunit

### Dependencies

- `jq-front`: Native version of `jq-front` somewhere on the `PATH`.

## Authors

* **Hrioshi Ukai** - *Initial work* - <a href="https://github.com/dakusui">
  dakusui</a>

## Support

* <a href="https://github.com/dakusui/commandunit/issues">Issues</a>
* Twitter at <a href="http://twitter.com/\______HU">@\______HU</a>

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2019 © <a href="https://github.com/dakusui" target="_blank">Hiroshi
  Ukai</a>.

END