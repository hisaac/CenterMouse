#!/usr/bin/env bash

set -o errexit  # Exit on error
set -o nounset  # Exit on unset variable
set -o pipefail # Exit on pipe failure

# Entry point for the "Generate Credits" Xcode build phase.
#
# This exists as a wrapper rather than an inline build phase script for two reasons: build phase
# scripts are painful to read and diff inside project.pbxproj, and Xcode runs them with a minimal
# PATH that does not include the usual Homebrew locations where mise lives.

export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH}"

if ! command -v mise >/dev/null 2>&1; then
	# Not a build failure. The generated Credits.html is checked in, so a build without mise still
	# produces a correct app, just without refreshing the credits first.
	echo "warning: mise not found, skipping credits generation"
	exit 0
fi

cd "${PROJECT_DIR}"
mise run credits
