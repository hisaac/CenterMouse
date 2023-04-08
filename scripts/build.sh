#!/bin/bash

set -o pipefail

if ! command -v xcbeautify &> /dev/null; then
	brew install xcbeautify
fi

xcrun xcodebuild clean build \
	-scheme "CenterMouse" \
	-derivedDataPath "DerivedData" \
	-clonedSourcePackagesDirPath "DerivedData/Packages" \
	CODE_SIGN_IDENTITY= | xcbeautify
