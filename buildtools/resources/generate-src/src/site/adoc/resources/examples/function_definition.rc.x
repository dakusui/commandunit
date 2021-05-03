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
  local _loglevel="ERROR"
  local _me
  local _image_name
  _me="${USER}"
  if [[ $1 == "--snapshot" ]]; then
    _image_version="${COMMANDUNIT_SNAPSHOT_VERSION}"
    _suffix="-snapshot"
    shift
  fi
  _image_name="${_docker_repo_name}:${_image_version}${_suffix}"
  if [[ $1 == "--debug" ]]; then
    _entrypoint="--entrypoint=/bin/bash"
    shift
  fi
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
END
