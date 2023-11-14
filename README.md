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

Place the following script in one of your directories on `PATH` environment variable entry with `755` permission.

```bash
#!/usr/bin/env bash

function __commandunit_exec_commandunit() {
  export PROJECT_BASE_DIR="${PWD}"
  export COMMANDUNIT_PWD="${PROJECT_BASE_DIR}" # Referenced by commandunit itself.
  export COMMANDUNIT_SOURCE_DIR="${PROJECT_BASE_DIR}/src/dependencies/commandunit"
export COMMANDUNIT_DEFAULT_VERSION="v1.26"
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
    local _image_name="${1}"
    shift
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
  function __commandunit_clean_cloned_commandunit() {
    local _version_name="${1}" _source_dir="${2:-${COMMANDUNIT_SOURCE_DIR}}"
    #      +-- Safeguard for a bug, where the variable becomes empty.
    #     |    Because this function removes everything under the dir.
    #     V
    if [[ "${_source_dir}/${_version_name}" == *"/src/dependencies/"* ]]; then
      if [[ -d "${_source_dir}/${_version_name}" ]]; then
        rm -fr "${_source_dir"?"}/${_version_name:?}"
      fi
    fi
  }
  function __commandunit_clone_commandunit() {
    local _git_tag_option="${1}" _version_name="${2}"
    local _out
    echo "version_name:${_source_dir}-/-${_version_name}" >&2
    # shellcheck disable=SC2086
    _out="$(git clone --depth 1 ${_git_tag_option} https://github.com/dakusui/commandunit.git "${COMMANDUNIT_SOURCE_DIR}/${_version_name}" 2>&1)" || {
      echo "Failed to clone<: ${_out}>" >&2
      return 1
    }
  }
  function __commandunit_exec_commandunit_native() {
    local _version_name="${1}"
    shift
    "${COMMANDUNIT_SOURCE_DIR}/${_version_name}/src/main/scripts/bin/commandunit-main" "${@}"
  }

  local _project_basedir="${PROJECT_BASE_DIR}"
  local _hostfsroot_mountpoint="/var/lib/commandunit"
  local _docker_repo_name="dakusui/commandunit"
  local _entrypoint=""
  local _native="no"
  local _loglevel="${COMMANDUNIT_LOGLEVEL:-ERROR}"
  local _image_name _image_version="${COMMANDUNIT_DEFAULT_VERSION}" _branch_name="main" _version_name=${COMMANDUNIT_DEFAULT_VERSION} _args _show_image_name=false _i _s _quit=false _help=false
  _args=()
  _s=to_func
  for _i in "${@}"; do
    if [[ "${_s}" == to_func ]]; then
      if [[ $_i == "--version="* ]]; then
        local _v="${_i#*=}"
        if [[ "${_v}" == "snapshot" ]]; then
          # _image_version="${COMMANDUNIT_VERSION%.*}.$((${COMMANDUNIT_VERSION##*.} + 1))"
          local _default_version="${COMMANDUNIT_DEFAULT_VERSION}" # v1.24
          _image_version="${_default_version%.*}.$((${_default_version##*.} + 1))"
        else
          _branch_name="${_v}"
          _image_version="${_v}"
        fi
        _version_name="${_v}"
        # --version=      snapshot               v1.99          (none)
        # _version_name   snapshot               v1.99           v1.24
        # _image_version  v1.25                  v1.99           v1.24          (private)
        # _image_name     dakusui:v1.25-snapshot dakusui:v1.99   dakusui:v1.24
        # _branch_name    main                   v1.99           v1.24
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
  _image_name="${_docker_repo_name}:${_image_version}"
  if [[ "${_version_name}" == "snapshot" ]]; then
    _image_name="${_image_name}-${_v}"
  fi
  if ${_show_image_name}; then
    echo "${_image_name}"
  fi
  if ${_help}; then
    echo "Usage: commandunit [WRAPPER OPTION]... [--] [OPTION]... [SUBCOMMAND]..."
    echo ""
    echo "A wrapper function for 'commandunit' to invoke its docker image.".
    echo "Followings are switching options to control the wrapper's behaviour."
    echo "Options not listed here or ones after the separator (--) are passed to the commandunit implementation directly."
    echo ""
    echo "Wrapper options:"
    echo "--native            Use the 'native' version of commandunit."
    echo "--version={VERSION} Use the specified version of commandunit. If 'snapshot' is given, a version under development is used (default: ${COMMANDUNIT_DEFAULT_VERSION})."
    echo "--debug-shell       Get the shell of the docker image. Type Ctrl-D to quit it. Development purpose only."
    echo "--show-image-name   Print the image name. Useful to figure out the version."
    echo "--quit              Quit before running the image. With --show-image-name, useful to figure out the image version"
    echo "--help              Show this help and pass the --help option to the docker image."
    echo "--                  A separator to let this wrapper know the options after it should be passed directly to the image"
    echo ""
  fi
  ${_quit} && return 0
  if [[ "${_native}" == "no" ]]; then
    __commandunit_exec_commandunit_docker "${_image_name}" "${_args[@]}"
  else
    which jq-front > /dev/null || {
      function jq-front() {
        docker run --rm -i \
          -v "${HOME}:/var/lib/jf/${HOME}" \
          -e JF_PATH_BASE="/var/lib/jf" \
          -e JF_PATH="${JF_PATH}" \
          -e JF_DEBUG=${JF_DEBUG:-disabled} \
          -e JF_CWD="$(pwd)" \
          -e COMMANDUNIT_DEPENDENCIES_ROOT="${COMMANDUNIT_DEPENDENCIES_ROOT:?Required environment variable is not set.}" \
          -e COMMANDUNIT_BUILTIN_ROOT="${COMMANDUNIT_DEPENDENCIES_ROOT:?Required environment variable is not set.}" \
          dakusui/jq-front:"${JF_DOCKER_TAG:-v0.53}" "${@}"
      } &&
      export -f jq-front
    }
    if [[ "${_version_name}" ==  "snapshot" ]]; then
      # Remove already loaded one, then... do clone
      __commandunit_clean_cloned_commandunit "${_version_name}"
    fi
    if [[ ! -e "${COMMANDUNIT_SOURCE_DIR}/${_version_name}" ]]; then
      __commandunit_clone_commandunit "--branch ${_branch_name}" "${_version_name}"
    fi
    __commandunit_exec_commandunit_native "${_version_name}" "${_args[@]}"
  fi
}

function main() {
  __commandunit_exec_commandunit "${@}"
}

main "${@}"
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

