#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p local/build
swiftc -parse-as-library -O -target arm64-apple-macosx14.0 Shared/*.swift CodexLimitWidgetApp/*.swift -o local/build/CustomApp
swiftc -parse-as-library -O -target arm64-apple-macosx14.0 -application-extension -module-name CodexLimitWidgetExtension -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk -Xlinker -e -Xlinker _NSExtensionMain Shared/*.swift CodexLimitWidgetExtension/*.swift -o local/build/CustomWidget
cp local/model-tests.swift local/build/main.swift
swiftc Shared/LimitModels.swift local/build/main.swift -o local/build/model-tests
local/build/model-tests
