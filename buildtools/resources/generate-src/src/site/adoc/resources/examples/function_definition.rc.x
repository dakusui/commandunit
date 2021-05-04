COMMANDUNIT_VERSION="${COMMANDUNIT_VERSION:-"${LATEST_RELEASED_VERSION}"}"
COMMANDUNIT_SNAPSHOT_VERSION="${COMMANDUNIT_SNAPSHOT_VERSION:-"${TARGET_VERSION}"}"
export COMMANDUNIT_VERSION
export COMMANDUNIT_SNAPSHOT_VERSION

# shellcheck disable=SC2154
envsubst '${COMMANDUNIT_VERSION} ${COMMANDUNIT_SNAPSHOT_VERSION} ${BUILD_HOSTFSROOT_MOUNTPOINT}' <<'END'
function commandunit() {
  local _project_basedir="${PWD}"
  local _hostfsroot_mountpoint="${BUILD_HOSTFSROOT_MOUNTPOINT}"
  local _docker_repo_name="dakusui/commandunit"
  local _image_version="${COMMANDUNIT_VERSION}"
  local _suffix=""
  local _entrypoint=""
  local _loglevel="${COMMANDUNIT_LOGLEVEL:-ERROR}"
  local _me _image_name _args _show_image_name=false _i
  _me="${USER}"
  _args=()
  for _i in "${@}"; do
    if [[ $_i == "--snapshot" ]]; then
      _image_version="${COMMANDUNIT_SNAPSHOT_VERSION}"
      _suffix="-snapshot"
    elif [[ $_i == "--debug" ]]; then
      _entrypoint="--entrypoint=/bin/bash"
    elif [[ $_i == "--show-image-name" ]]; then
      _show_image_name=true
    elif [[ $_i == "--" ]]; then
      break
    else
      _args+=("${_i}")
    fi
  done
  _image_name="${_docker_repo_name}:${_image_version}${_suffix}"
  if ${_show_image_name}; then
    echo "${_image_name}" >&2
  fi
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
END
