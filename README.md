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
function commandunit() {
  local _project_basedir="${PWD}"
  local _hostfsroot_mountpoint="/var/lib/commandunit"
  local _docker_repo_name="dakusui/commandunit"
  local _image_version="v1.17"
  local _suffix=""
  local _entrypoint=""
  local _loglevel="${COMMANDUNIT_LOGLEVEL:-ERROR}"
  local _me _image_name _args _show_image_name=false _i _s _quit=false _help=false
  _me="${USER}"
  _args=()
  _s=to_func
  for _i in "${@}"; do
    if [[ "${_s}" == to_func ]]; then
        if [[ $_i == "--snapshot" ]]; then
          _image_version="v1.18"
          _suffix="-snapshot"
        elif [[ $_i == "--debug" ]]; then
          _entrypoint="--entrypoint=/bin/bash"
        elif [[ $_i == "--show-image-name" ]]; then
          _show_image_name=true
        elif [[ $_i == "--quit" ]]; then
          _quit=true
        elif [[ $_i == "--help" ]]; then
          _help=true
          _args+=("${_i}")
        elif [[ $_i == "--" ]]; then
          _s=to_container
        else
          _args+=("${_i}")
        fi
    else
      _args+=("${_i}")
    fi
  done
  _image_name="${_docker_repo_name}:${_image_version}${_suffix}"
  if ${_show_image_name}; then
    echo "${_image_name}"
  fi
  if ${_help}; then
    echo "Usage: commandunit [WRAPPER OPTION]... [--] [OPTION]... [SUBCOMMAND]..."
    echo ""
    echo "A wrapper function for 'commandunit' to invoke its docker image.".
    echo "Followings are switching options to control the wrapper's behaviour."
    echo "Options not listed here or ones after the separator (--) are passed to the docker image directly."
    echo ""
    echo "Wrapper options:"
    echo "--snapshot        Use the snapshot image instead of the latest released one. Development purpose only."
    echo "--debug           Get the shell of the docker image. Type Ctrl-D to quit it. Development purpose only."
    echo "--show-image-name Print the image name. Useful to figure out the version."
    echo "--quit            Quit before running the image. With --show-image-name, useful to figure out the image version"
    echo "--help            Show this help and pass the --help option to the docker image."
    echo "--                A separator to let this wrapper know the options after it should be passed directly to the image"
    echo ""
  fi
  ${_quit} && return 0
  # shellcheck disable=SC2086
  docker run \
    --user="$(id -u "${_me}"):$(id -g "${_me}")" \
    --env COMMANDUNIT_PWD="${_project_basedir}" \
    --env COMMANDUNIT_LOGLEVEL="${_loglevel}" \
    -v "${_project_basedir}:${_hostfsroot_mountpoint}${_project_basedir}" \
    ${_entrypoint} \
    -i "${_image_name}" \
    "${_args[@]}"
}
export -f commandunit
```

Or run the following one-liner.

```bash
app="commandunit"
rc="$HOME/.${app}rc" && \
target="$HOME/.bashrc" && \
tag="#-${app^^}" && \
cat <(curl "https://raw.githubusercontent.com/dakusui/commandunit/main/src/site/adoc/resources/examples/function_definition.rc") > "${rc}" && \
sh -c 'grep "$4" "$1" >& /dev/null || printf "source $3$2$3 $4\n" >> "$1"' - "${target}" "${rc}" '"' "${tag}"
```

If you are on `macOS`, make sure `~/.bashrc` is read by `~/.bash_profile`.

## Authors

* **Hrioshi Ukai** - *Initial work* - <a href="https://github.com/dakusui">
  dakusui</a>

## Support

* <a href="https://github.com/dakusui/commandunit/issues">Issues</a>
* Twitter at <a href="http://twitter.com/\______HU">@\______HU</a>

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2019 ?? <a href="https://github.com/dakusui" target="_blank">Hiroshi
  Ukai</a>.

