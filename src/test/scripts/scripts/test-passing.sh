source "${APP_HOME}/lib/commandunit-core.rc"

export BUD_DEBUG=enabled

echo "PREPARE TEST" >&2
_tmp_dir=$(mktemp -d)
function bud__directory_for_output() {
  echo "${_tmp_dir}"
}
_test_json="$(jq -rcM . "$(dirname ${BASH_SOURCE[0]})/data/passing.json")"

echo "RUN TEST (EXECUTION ONLY)" >&2
_result_json="$(execute_test_json "${_test_json}" | jq .)"

echo "CHECK TEST RESULT" >&2
_success=$(echo "${_result_json}" | jq -crM .report.result.success)
if [[ "${_success}" == true ]]; then
  exit 0
else
  echo "_success: ${_success}" >&2
  echo "_result_json: '${_result_json}'" >&2
  exit 1
fi
echo "DONE" >&2
