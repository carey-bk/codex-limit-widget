# Custom build notes

Based on upstream v1.2.304, commit d00fe2a. Packaged custom build: 159.

## Source changes

- Display-friendly plan names and reset dates.
- Read-only bank reset lookup, nullable count and freshness timestamp.
- Daily usage history in the snapshot; calendar-based seven-day chart and conditional TODAY label.
- Large editorial layout, four lower metrics, plan/message placement and spacing refinements.

## Compile

The published binaries were built on Apple Silicon with Swift 6.3.3 Command Line Tools. The extension uses the macOS 15.4 SDK and the `_NSExtensionMain` entry point. A normal executable entry point makes the extension exit immediately on the tested system, leaving old WidgetKit snapshots visible.

```sh
bash local/build.sh
```

This produces `local/build/CustomApp`, `local/build/CustomWidget` and model-test results. The script requires the macOS 15.4 SDK at its standard Command Line Tools location. Binaries alone are not installable app bundles.

For packaging, supply an unpacked upstream v1.2.304 app bundle as the resource template:

```sh
bash local/package.sh '/path/to/Codex Limit Widget.app'
```

The script copies the template to a build staging folder, replaces both executables with locally compiled versions, sets build 159, ad-hoc signs the app and widget extension, and creates a DMG. Original bundle identifiers are retained. Never commit auth.json or local Application Support snapshots.

The upstream Xcode release workflow is retained for reference but has been changed to manual-only so it cannot accidentally overwrite custom release assets. Its release script is still the upstream release process, not the custom packaging process.

## Validation

- Compiled app and extension on arm64; model tests cover plan names, fresh/stale/unknown bank resets, legacy snapshots, seven consecutive dates, missing versus zero, and TODAY selection.
- Rendered at the actual 344-point large-widget size and visually checked, including the longer middle-tier message.
- Confirmed installed extension startup and chronod timeline Reload success after installation.
- Verified DMG checksums, mounted read-only, checked signatures and compared all app files against the installed build.

Historical screenshot statistics are illustrative, not current account status. The system glass appearance is provided by macOS; standalone previews use an opaque background.
