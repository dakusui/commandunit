source "${APP_HOME}/lib/cmd_unit.rc"

export BUD_DEBUG=enabled

echo "PREPARE TEST"
_tmp_dir=$(mktemp -d)
function bud__directory_for_output() {
  echo "${_tmp_dir}"
}
_test_json="$(jq -rcM . "$(dirname "${BASH_SOURCE[0]}")"/data/passing.json)"

echo "RUN TEST (PRECHECK ONLY)" >&2
_result_json=$(precheck_test_json "${_test_json}")

echo "CHECK TEST RESULT" >&2
_precheck=$(echo "${_result_json}" | jq -crM .report.result.precheck)
if [[ "${_precheck}" == true ]]; then
  exit 0
else
  echo "_precheck: ${_precheck}" >&2
  echo "_result_json: '${_result_json}'" >&2
  exit 1
fi
echo "DONE" >&2
