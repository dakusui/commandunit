export COMMANDUNIT_VERSION="${COMMANDUNIT_VERSION:="${LATEST_RELEASED_VERSION}"}"
# shellcheck disable=SC2154
envsubst '${COMMANDUNIT_VERSION}' <<'END'
function commandunit() {
  local _image_version="${COMMANDUNIT_VERSION}"
  local _image_name="dakusui/commandunit:${_image_version}"
  local _commandunit_dockerdir_prefix="/var/lib/commandunit"
  local _project_dir _me _info_log
  _me="$(whoami)"
  _project_dir="$(pwd)"
  _info_log="${BUD_INFO:-disabled}"
  docker run \
    --user="$(id -u "${_me}"):$(id -g "${_me}")" \
    --env COMMANDUNIT_PWD="${PWD}" \
    --env PROJECT_NAME="commandunit" \
    --env COMMANDUNIT_DOCKERDIR_PREFIX="${_commandunit_dockerdir_prefix}" \
    --env BUD_INFO="${_info_log}" \
    -v "${_project_dir}:${_commandunit_dockerdir_prefix}${_project_dir}" \
    -i "${_image_name}" \
    "${@}"
}
export -f commandunit
END