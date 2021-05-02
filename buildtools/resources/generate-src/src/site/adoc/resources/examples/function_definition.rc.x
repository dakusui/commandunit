export COMMANDUNIT_VERSION="${COMMANDUNIT_VERSION:="${LATEST_RELEASED_VERSION}"}"
# shellcheck disable=SC2154
envsubst '${COMMANDUNIT_VERSION} ${BUILD_HOSTFSROOT_MOUNTPOINT}' <<'END'
function commandunit() {
  local _image_version="${COMMANDUNIT_VERSION}"
  local _image_name="dakusui/commandunit:${_image_version}"
  local _project_name _project_basedir _pwd _me _loglevel
  _pwd="${PWD}"
  _me="${USER}"
  _project_name="unknown"
  _project_basedir="${_pwd}"
  _loglevel="${COMMANDUNIT_LOGLEVEL:-error}"
  docker run \
    --user="$(id -u "${_me}"):$(id -g "${_me}")" \
    --env PROJECT_NAME="${_project_name}" \
    --env PROJECT_BASEDIR="${_project_basedir}" \
    --env COMMANDUNIT_LOGLEVEL="${_loglevel}" \
    -v "${_project_basedir}:${BUILD_HOSTFSROOT_MOUNTPOINT}${_project_basedir}" \
    -i "${_image_name}" \
    "${@}"
}
export -f commandunit
END
