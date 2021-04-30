export COMMANDUNIT_VERSION="${COMMANDUNIT_VERSION:="${LATEST_RELEASED_VERSION}"}"
# shellcheck disable=SC2154
envsubst '${COMMANDUNIT_VERSION}' <<'END'
function commandunit() {
  local _image_version="${COMMANDUNIT_VERSION}"
  local _image_name="dakusui/commandunit:${_image_version}"
  local _project_name _project_dir _pwd _me _info_log
  _pwd="${PWD}"
  _me="${USER}"
  _project_name="unknown"
  _project_dir="${_pwd}"
  _info_log="${BUD_INFO:-disabled}"
  docker run \
    --user="$(id -u "${_me}"):$(id -g "${_me}")" \
    --env PROJECT_NAME="${_project_name}" \
    --env COMMANDUNIT_PWD="${PWD}" \
    --env BUD_INFO="${_info_log}" \
    -v "${_project_dir}:/var/lib/commandunit${_project_dir}" \
    -i "${_image_name}" \
    "${@}"
}
export -f commandunit
END
