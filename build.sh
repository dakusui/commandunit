#!/usr/bin/env bash

set -eu -o pipefail -o errtrace
shopt -s inherit_errexit nullglob # compat"${BASH_COMPAT=42}"

source "$(dirname "${BASH_SOURCE[0]}")/buildtools/utils.rc"
source "$(dirname "${BASH_SOURCE[0]}")/buildtools/build_info.rc"

__execute_stage_driver_filename=
__execute_stage_stage_name=
function __execute_stage() {
  local _stage="${1}"
  shift
  message "EXECUTING:${_stage}:'${*}'"
  {
    __execute_stage_driver_filename="$(dirname "${BASH_SOURCE[0]}")/buildtools/drivers/${_stage}.rc"
    __execute_stage_stage_name="${_stage}"
    function execute_stage() {
      abort "The driver: '${__execute_stage_driver_filename}' does not define a function 'execute_stage'"
    }
    function stage_name() {
      abort "The driver: '${__execute_stage_driver_filename}' does not define a function 'stage_name'"
    }
    # shellcheck disable=SC1090
    source "${__execute_stage_driver_filename}" || abort "Driver not found: '${__execute_stage_driver_filename}'"
    function stage_name() {
      echo "'${__execute_stage_stage_name}'"
    }
    "execute_stage" "$@" && message "DONE:${_stage}"
  } || {
    message "FAILED:${_stage}"
    return 1
  }
  return 0
}

function execute() {
  if [[ "${#@}" == 0 ]]; then
    return 0
  fi
  local _first="${1}"
  shift
  if [[ "${_first}" == BUILD ]]; then
    execute clean prepare doc test "${@}"
  elif [[ "${_first}" == DOC ]]; then
    execute clean prepare doc "${@}"
  elif [[ ${_first} == DOC ]]; then
    execute clean prepare doc "${@}"
  elif [[ ${_first} == TEST ]]; then
    execute clean prepare test "${@}"
  elif [[ ${_first} == COVERAGE ]]; then
    execute clean prepare doc coverage "${@}"
  elif [[ ${_first} == PACKAGE ]]; then
    execute clean prepare test build:snapshot test:snapshot "${@}"
  elif [[ ${_first} == RELEASE ]]; then
    execute clean release-precheck prepare test build:release test:release push:release release-postmortem "${@}"
  elif [[ ${_first} == PUBLISH_DOC ]]; then
    execute clean prepare publish-doc "${@}"
  else
    IFS=':' read -r -a _args <<<"${_first}"
    __execute_stage "${_args[@]}" || exit 1
    execute "${@}"
  fi
}

function main() {
  if [[ "${#@}" == 0 ]]; then
    execute BUILD
  else
    execute "${@}"
  fi
}

main "${@}"
