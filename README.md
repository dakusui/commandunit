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
your `~/.bashrc` or `~/.bash_profile`.

```bash
function commandunit() {
  local _project_basedir="${PWD}"
  local _hostfsroot_mountpoint="/var/lib/commandunit"
  local _docker_repo_name="dakusui/commandunit"
  local _image_version="v1.10"
  local _suffix=""
  local _entrypoint=""
  local _loglevel="ERROR"
  local _me
  local _image_name
  _me="${USER}"
  if [[ $1 == "--snapshot" ]]; then
    _image_version="v1.11"
    _suffix="-snapshot"
    shift
  fi
  _image_name="${_docker_repo_name}:${_image_version}${_suffix}"
  if [[ $1 == "--debug" ]]; then
    _entrypoint="--entrypoint=/bin/bash"
    shift
  fi
  echo "image='${_image_name}'" >&2
  # shellcheck disable=SC2086
  docker run \
    --user="$(id -u "${_me}"):$(id -g "${_me}")" \
    --env COMMANDUNIT_PWD="${_project_basedir}" \
    --env COMMANDUNIT_LOGLEVEL="${_loglevel}" \
    -v "${_project_basedir}:${_hostfsroot_mountpoint}${_project_basedir}" \
    ${_entrypoint} \
    -i "${_image_name}" \
    "${@}"
}
export -f commandunit
```

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

