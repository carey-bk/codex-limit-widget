#!/bin/bash
set -euo pipefail
source_app=${1:?Usage: bash local/package.sh /path/to/upstream.app}
source_app=$(cd "$source_app" && pwd)
cd "$(dirname "$0")/.."
test -f "$source_app/Contents/Info.plist"
bash local/build.sh
stage=$(mktemp -d "$PWD/local/build/package.XXXXXX")
trap 'rm -rf "$stage"' EXIT
app="$stage/Codex Limit Widget.app"
ditto "$source_app" "$app"
cp local/build/CustomApp "$app/Contents/MacOS/Codex Limit Widget"
cp local/build/CustomWidget "$app/Contents/PlugIns/CodexLimitWidgetExtension.appex/Contents/MacOS/CodexLimitWidgetExtension"
/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 159' "$app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 159' "$app/Contents/PlugIns/CodexLimitWidgetExtension.appex/Contents/Info.plist"
codesign --force --sign - --entitlements CodexLimitWidgetExtension/CodexLimitWidgetExtension.entitlements "$app/Contents/PlugIns/CodexLimitWidgetExtension.appex"
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"
ln -s /Applications "$stage/Applications"
mkdir -p release
hdiutil create -volname 'Codex Limit Widget Custom' -srcfolder "$stage" -ov -format UDZO release/Codex-Limit-Widget-Custom-1.2.304-build159.dmg
hdiutil verify release/Codex-Limit-Widget-Custom-1.2.304-build159.dmg
