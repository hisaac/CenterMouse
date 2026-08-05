#!/usr/bin/env bash

set -o errexit  # Exit on error
set -o nounset  # Exit on unset variable
set -o pipefail # Exit on pipe failure

# Output extra debug logging if `DEBUG` or `TRACE` are set to `true` or `RUNNER_DEBUG` is set to `1`
# (https://docs.github.com/en/actions/reference/workflows-and-actions/variables)
if [[ "${DEBUG:-}" == "true" || "${TRACE:-}" == true || "${RUNNER_DEBUG:-}" == "1" ]]; then
	set -o xtrace # Trace the execution of the script (debug)
fi

# xcbeautify is lossy by design, so the raw log is kept for when the pretty output is not enough
# to diagnose a failure. Overwritten each build; see .artifacts in .gitignore.
declare -r log_file="${PROJECT_ROOT}/.artifacts/xcodebuild"

function main() {
	# "platform=macOS" alone matches both the arm64 and x86_64 destinations for this Mac, which
	# makes xcodebuild warn and silently pick the first. Resolving the arch here keeps the choice
	# explicit while still doing the right thing on both Apple silicon and Intel machines.
	declare -r arch="$(uname -m)"

	mkdir -p "${log_file%/*}"

	# `pipefail` is what makes this safe: tee always succeeds, so without it a failing xcodebuild
	# would be masked by the exit status of the last command in the pipeline.
	xcrun xcodebuild build \
		-scheme "CenterMouse" \
		-destination "platform=macOS,arch=${arch}" \
		-derivedDataPath "${PROJECT_ROOT}/DerivedData" \
		CODE_SIGN_IDENTITY= 2>&1 | tee "${log_file}" | xcbeautify
}

trap handle_exit EXIT
function handle_exit() {
	declare -ri exit_code="$?"
	if [[ "${exit_code}" -ne 0 ]]; then
		declare -r script_name="${0##*/}"
		echo -e "\n==> ${script_name} exited with code ${exit_code}"
	fi
}

main "$@"
