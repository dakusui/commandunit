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
  export PROJECT_BASE_DIR="${PWD}"
  export COMMANDUNIT_SOURCE_DIR="${PROJECT_BASE_DIR}/src/dependencies/commandunit"
  export COMMANDUNIT_VERSION="${COMMANDUNIT_VERSION:v1.25}"
  export COMMANDUNIT_MINOR_VERSION="${COMMANDUNIT_VERSION##*.}"
  export COMMANDUNIT_SNAPSHOT_VERSION="v1.$((${COMMANDUNIT_MINOR_VERSION} + 1))"
  export BUD_DEBUG=enabled
  function __commandunit_user_option() {
    case "$(uname -sr)" in

    Darwin*)
      echo -n "-u" "1000:1000"
      ;;

    Linux*Microsoft*)
      echo -n "-u" "$(id -u):$(id -g)"
      ;;

    Linux*)
      echo -n "-u" "$(id -u):$(id -g)"
      ;;

    CYGWIN* | MINGW* | MSYS*)
      echo -n "-u" "$(id -u):$(id -g)"
      ;;

    # Add here more strings to compare
    # See correspondence table at the bottom of this answer

    *)
      echo -n "-u" "$(id -u):$(id -g)"
      ;;
    esac
  }
  function __commandunit_exec_commandunit_docker() {
    # shellcheck disable=SC2086
    # shellcheck disable=SC2046
    docker run \
      $(__commandunit_user_option) \
      --env COMMANDUNIT_PWD="${_project_basedir}" \
      --env COMMANDUNIT_LOGLEVEL="${_loglevel}" \
      --env TMPDIR="/tmp" \
      -v "${_project_basedir}:${_hostfsroot_mountpoint}${_project_basedir}" \
      ${_entrypoint} \
      -i "${_image_name}" \
      "${@}"
  }
  local _project_basedir="${PROJECT_BASE_DIR}"
  local _hostfsroot_mountpoint="/var/lib/commandunit"
  local _docker_repo_name="dakusui/commandunit"
  local _image_version="${COMMANDUNIT_VERSION}"
  local _suffix=""
  local _commandunit_version="${COMMANDUNIT_VERSION}"
  local _entrypoint=""
  local _native="no"
  local _loglevel="${COMMANDUNIT_LOGLEVEL:-ERROR}"
  local _image_name _args _show_image_name=false _i _s _quit=false _help=false
  _args=()
  _s=to_func
  for _i in "${@}"; do
    if [[ "${_s}" == to_func ]]; then
      if [[ $_i == "--snapshot" ]]; then
        _image_version="${COMMANDUNIT_SNAPSHOT_VERSION}"
        _suffix="-snapshot"
      elif [[ $_i == "--native" ]]; then
        _native="yes"
      elif [[ $_i == "--debug-shell" ]]; then
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
    echo "--native          Use the 'native' version of commandunit."
    echo "--snapshot        Use the snapshot image instead of the latest released one. Development purpose only."
    echo "--debug-shell     Get the shell of the docker image. Type Ctrl-D to quit it. Development purpose only."
    echo "--show-image-name Print the image name. Useful to figure out the version."
    echo "--quit            Quit before running the image. With --show-image-name, useful to figure out the image version"
    echo "--help            Show this help and pass the --help option to the docker image."
    echo "--                A separator to let this wrapper know the options after it should be passed directly to the image"
    echo ""
  fi
  ${_quit} && return 0
  if [[ "${_native}" == "no" ]]; then
    __commandunit_exec_commandunit_docker "${_args[@]}"
  else
    which jq-front || {
      function jq-front() {
        docker run --rm -i \
          -v /:/var/lib/jf \
          -v "${HOME}/.jq-front.rc:/root/.jq-front.rc" \
          -e JF_PATH_BASE="/var/lib/jf" \
          -e JF_PATH="${JF_PATH}" \
          -e JF_DEBUG=${JF_DEBUG:-disabled} \
          -e JF_CWD="$(pwd)" \
          -e COMMANDUNIT_DEPENDENCIES_ROOT="${COMMANDUNIT_DEPENDENCIES_ROOT:?Required environment variable is not set.}" \
          dakusui/jq-front:"${JF_DOCKER_TAG:-v0.54}" "${@}"
      } &&
      export -f jq-front
    }
    #     __commandunit_refresh_cloned_commandunit "--branch ${COMMANDUNIT_VERSION}" "${_commandunit_version}" || return "${?}"
    # __commandunit_refresh_cloned_commandunit "" "${_suffix}"
    local _local_source_suffix
    if [[ "${_suffix}" ==  "-snapshot" ]]; then
      _local_source_suffix="${_suffix}"
      # Remove already loaded one, then... do clone
      __commandunit_clean_cloned_commandunit "${_local_source_suffix}"
      __commandunit_clone_commandunit "--branch main" "${_local_source_suffix}"
    else
      _local_source_suffix="-${_commandunit_version}"
      if [[ ! -e "${COMMANDUNIT_SOURCE_DIR}-${_commandunit_version}" ]]; then
        __commandunit_clone_commandunit "--branch ${_commandunit_version}" "${_local_source_suffix}"
      fi
    fi
    __commandunit_exec_commandunit_native "${_local_source_suffix}" "${_args[@]}"
  fi
}

function __commandunit_clean_cloned_commandunit() {
  local _suffix="${1}"
  #      +-- Safeguard for a bug, where the variable becomes empty.
  #     |    Because this function removes everything under the dir.
  #     V
  if [[ "${COMMANDUNIT_SOURCE_DIR}${_suffix}" == *"/src/dependencies/"* ]]; then
    if [[ -d "${COMMANDUNIT_SOURCE_DIR}${_suffix}" ]]; then
      rm -fr "${COMMANDUNIT_SOURCE_DIR}${_suffix}"
    fi
  fi
}

function __commandunit_clone_commandunit() {
  local _git_tag_option="${1}" _snapshot_suffix="${2}"
  local _out
  # shellcheck disable=SC2086
  _out="$(git clone --depth 1 ${_git_tag_option} https://github.com/dakusui/commandunit.git "${COMMANDUNIT_SOURCE_DIR}${_snapshot_suffix}" 2>&1)" || {
    echo "Failed to clone<: ${_out}>" >&2
    return 1
  }
}

function __commandunit_exec_commandunit_native() {
  local _suffix="${1}"
  shift
  "${COMMANDUNIT_SOURCE_DIR}${_suffix}/src/main/scripts/bin/commandunit" "${@}"
}
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

