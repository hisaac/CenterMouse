#!/usr/bin/env bash -euo pipefail

if ! command -v xcbeautify &> /dev/null; then
	echo "xcbeautify could not be found"
	exit 1
fi

xcrun xcodebuild build \
	-scheme "CenterMouse" \
	-derivedDataPath "DerivedData" | xcbeautify
