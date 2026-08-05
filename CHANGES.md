# Maintenance pass — August 2026

Notes on the changes in the `fixes-and-cleanup` branch: what changed, why, and how each
change was verified. Scope was deliberately limited to correctness fixes, dead code removal,
and build tooling. No new features, no dependency upgrades, no language mode changes.

## Bug fixes

### The keyboard shortcut stopped working when system event monitoring was off

The most significant fix. `MouseMover.moveMouseToCenterOfMainScreen()` checked
`Defaults[.monitorSystemEvents]` before doing anything, and *both* the system event handlers
and the global keyboard shortcut called that same function. So unchecking "Move mouse to
center on system events" silently disabled the keyboard shortcut too, with nothing in the UI
suggesting the two were connected.

`MouseMover` now has two entry points:

- `handleSystemEvent(_:)` — honors the preference, used by the notification subscriptions.
- `centerMousePointer()` — unconditional, used by the keyboard shortcut.

If the user presses the shortcut, they want the pointer moved. The preference is about
*automatic* behavior only.

**Verified:** with `monitorSystemEvents` set to `false` and a `⌃⌥⌘C` shortcut registered,
pressing the shortcut on the original build left the pointer at `400,780` (unchanged). After
the fix, under identical conditions, the pointer moved to `960,540` — the center of the
primary display.

### The pointer targeted the wrong display

The code used `NSScreen.main`, which is not the primary display — it is the screen containing
the key window. If the settings window sat on a secondary monitor, that became the target,
contradicting the README's promise of the primary display. Now uses `NSScreen.screens.first`,
which is documented to be the primary screen.

There is a subtlety worth preserving, so it is now a comment in the source. `NSScreen.frame`
is in AppKit coordinates (origin bottom-left) while `CGWarpMouseCursorPosition` expects global
display coordinates (origin top-left). The original code did no conversion between them and
still worked, because the primary display is the one screen where both systems put the origin
in the same place, making the computed center identical either way. Pinning to the primary
display keeps that assumption valid; extending this code to other screens would require a real
conversion.

**Caveat:** this fix follows from the API contract, not from observation. The test machine had
a single display attached, so the old and new behavior could not be empirically distinguished.

### Launching as a login item stole focus

`Settings.setActivationPolicy` called `NSApp.activate(ignoringOtherApps: true)` unconditionally,
and `EventMonitor`'s `Defaults.publisher(.hideDockIcon)` emits on subscribe by default. The
subscription is created during `AppDelegate` property initialization, so every launch — including
launch as a login item — activated the app. The `launchedAsLogInItem` check correctly suppressed
the *window*, but the app still jumped to the foreground and took over the menu bar at login.

Now the publisher observes changes only (`options: []`), and `AppDelegate` applies the stored
policy at launch via `setActivationPolicy(activate: false)`. Activation still happens when the
user toggles the Dock icon setting, which is when it is actually wanted — switching to `.regular`
while frontmost otherwise leaves the app behind other windows.

### Stale credits

The About panel credited [Preferences](https://github.com/sindresorhus/Preferences), which has
not been a dependency for some time, and omitted LaunchAtLogin entirely. Corrected to match the
three packages actually in use.

### The About panel showed different things depending on how it was opened

The "About" button in the settings window called `orderFrontStandardAboutPanel(options:)` and
passed credits. The "About CenterMouse" item in the menu bar is wired in `MainMenu.xib` straight
to the standard `orderFrontStandardAboutPanel:` action, which takes no options — so it showed a
bare panel with no credits at all. Two different About experiences from one app.

Fixed by moving the credits out of code and into a bundled credits file, which the standard About
panel picks up automatically with no options dictionary and no code, so both entry points now
show the same thing. `SettingsView` calls `NSApp.orderFrontStandardAboutPanel(nil)` and
`LocalizedStrings.swift` is deleted — 77 lines of `NSMutableAttributedString` assembly replaced
by a resource file. That file started as `Credits.rtf` and is now the generated `Credits.html`
described under *Credits are now generated from the dependency graph* below.

**Verified:** both paths now produce a 284×318 panel with identical text and all four links
present as live accessibility elements. The menu bar path previously produced a bare 284×170
panel.

One trap worth recording, because it is silent and easy to hit in either format. The original RTF
was generated from an `NSAttributedString` built with `NSFont.preferredFont(forTextStyle:)`, which
serializes *private* system font names such as `.SFNS-BoldItalic`. Those cannot be resolved on
read, and CoreText silently substitutes Times New Roman — the panel would have rendered the role
headings in a serif face with no error anywhere. The same applies to the HTML, which is parsed by
the `NSAttributedString` importer rather than a browser engine: it asks for `Helvetica Neue`, a
family that actually resolves. Whatever the format, do not assume the system font survives a trip
through a document format.

## Dead code removal

- **`Font.swift` (150 lines)** — a vendored set of `NSFont` convenience extensions, of which
  exactly two were used: `NSFont.title3` and `NSFont.headline.boldAndItalic()`. The file is gone;
  its two remaining uses disappeared entirely when credits moved out of Swift.
- **`LocalizedStrings.swift` (77 lines)** — built the credits as an attributed string at runtime.
  Replaced by the generated credits resource described above.
- **`Extensions.swift`** — existed only so the credits could pass string literals where `URL`
  was expected. It declared a retroactive conformance of `Foundation.URL` to
  `ExpressibleByStringLiteral`, which was the source of the only compiler warning in the
  project. Removed along with the Swift-built credits that needed it.
- **The "Print Build Settings to Log" build phase** — ran `export` and was marked always-out-of-date,
  forcing a script phase to run on every single build for output nobody was reading.
- **Assorted** — a `deinit` that duplicated what `Set<AnyCancellable>` already does on
  deallocation, a `link:` parameter on `creditedPerson` that no call site ever passed, and two
  notification names (`screensaver.didstart` / `didstop`) that were declared but unused because
  they are never delivered. The knowledge that they don't work is preserved as a comment.
- **`print()` → `OSLog`** — the app logged to stdout in release builds. Now uses a `Logger` with
  the bundle identifier as subsystem.

Net effect on the app target: **−154 lines of Swift** (244 deletions against 90 insertions), plus
a generated HTML credits resource, and the build is now free of project-owned warnings.

## Build tooling

### Xcode pin was inert

`mise.toml` pinned Xcode `26.5.0`, which is not installed. Every build printed
`No Xcode installation matching version 26.5.0 was found` and left `DEVELOPER_DIR` unset, so the
pin did nothing and builds silently used whatever `xcode-select` pointed at — locally and in CI.
Bumped to `26.6.0`, the installed version. `DEVELOPER_DIR` now correctly resolves to
`/Applications/Xcode-26.6.0.app/Contents/Developer`, so the pin actually pins.

The plugin's `matches_fuzzy` compares only as many version components as you write, so `26.6`
would work identically; three components were used to match the file's existing style.

### Credits are now generated from the dependency graph

The library list was maintained by hand, which is how `Preferences` stayed credited long after it
stopped being a dependency. [LicensePlist](https://github.com/mono0926/LicensePlist) now generates
it from the resolved packages.

- Installed through mise's `github` backend (`"github:mono0926/LicensePlist" = "3.28.0"`), which
  verifies GitHub artifact attestations on download.
- `mise run credits` regenerates `CenterMouse/Resources/Credits.html` via
  `scripts/generate-credits.bash`.
- A "Generate Credits" Xcode build phase runs that task before the Sources and Resources phases,
  so a build always ships current credits.

The hand-maintained part (project link, the people) lives in the script; the libraries come from
LicensePlist, including full license texts and links to each source repository.

**Note on the output format.** LicensePlist's headline feature is a plist for `Settings.bundle`,
which is iOS-only — nothing on macOS would ever read it. The output that actually surfaces here is
HTML, because the About panel picks up `Credits.html` the same way it picked up `Credits.rtf`. The
RTF is therefore replaced rather than supplemented.

Four things had to be solved to make the build phase work, all worth knowing before touching it:

1. **User script sandboxing.** `ENABLE_USER_SCRIPT_SANDBOXING` is on, and it initially denied the
   phase even permission to *read* its own script. Fixed by declaring `inputPaths`
   (the two scripts, `mise.toml`, `Package.resolved`) and `outputPaths` (`Credits.html`) rather
   than by disabling the setting. That also lets Xcode do proper dependency analysis, so the phase
   runs only when the dependency graph changes instead of on every build.
2. **Where LicensePlist caches.** Its cache is what stops it hitting the network on every build,
   but the sandbox only grants writes to declared outputs and the phase's own temp directory.
   `DERIVED_FILE_DIR` is not usable — the sandbox will not even let the script create it — so the
   cache lives under `TARGET_TEMP_DIR` when running inside Xcode.
3. **LicensePlist credited itself.** Version 3.28.0 added `mise.toml` as a dependency source, so
   putting LicensePlist in `[tools]` made it appear in the app's own acknowledgements. `mise.toml`
   lists build tools, not things linked into the app, so the script points `--mise-path` at an
   empty config. It must still be *named* `mise.toml` or LicensePlist rejects the path outright.
4. **`--add-sources` emits malformed HTML.** It produces `<a href="URL"<h2>Name</h2></a>` — an
   opening tag that is never closed. The compose step rewrites that into a proper linked heading.

**Verified:** a clean build with no `Credits.html` present regenerates it and succeeds with
sandboxing enabled; subsequent builds skip the phase entirely; touching `Package.resolved`
re-triggers it; and the About panel renders all four links with fonts resolving correctly.

CI passes `LICENSE_PLIST_GITHUB_TOKEN` from the workflow's `GITHUB_TOKEN`, because the license
lookups hit the GitHub API and unauthenticated requests are rate limited hard enough to make
builds flaky.

### Ambiguous build destination

`xcodebuild` warned `Using the first of multiple matching destinations`. Adding
`-destination "platform=macOS"` was not sufficient — the two candidates were the *same* Mac at
`arm64` and `x86_64`. The architecture is now resolved from `uname -m` rather than hard-coded,
which silences the warning without breaking destination matching on an Intel host or CI runner.

## How this was verified

Beyond compiling, the built app was launched and driven through the accessibility API:

- Settings window renders correctly.
- About panel credits confirmed by reading the live text view — the corrected library list,
  the working `hisaac.net/CenterMouse` link, and the bold-italic role headings all render.
- Pointer behavior tested by posting real `com.apple.screenIsLocked` distributed notifications
  and sampling the cursor position before and after: it centers when the preference is on,
  stays put when off, and the keyboard shortcut works in both cases.

Test state was cleaned up afterward. The `software.level.CenterMouse` preferences domain was
written to during testing and then removed; there was no installed App Store copy and no sandbox
container, so that plist was entirely a test artifact.

### Raw xcodebuild output is kept

`xcbeautify` is lossy by design, and the detail it drops is often exactly what is needed to
diagnose a failure — the sandbox denials behind the credits build phase were invisible in the
pretty output. The build now tees the raw log to `.artifacts/xcodebuild` (gitignored) before
piping to `xcbeautify`.

`pipefail` is what makes this safe. `tee` always succeeds, so without it a failing `xcodebuild`
would be masked by the exit status of the last command in the pipeline. Verified that a non-zero
status still propagates through the added stage.

### Build settings moved into xcconfig files

Extracted with `tuist migration settings-to-xcconfig` into `Config/Project.xcconfig` and
`Config/CenterMouse.xcconfig`, wired up as the `baseConfigurationReference` for all four build
configurations. The corresponding `buildSettings` dictionaries in `project.pbxproj` are now empty,
which matters: anything left in them would silently override the xcconfig.

Settings that differ per configuration are preserved with `[config=Debug]` / `[config=Release]`
qualifiers, so the Debug/Release split survives intact.

**Verified** by diffing `xcodebuild -showBuildSettings` for both configurations before and after.
Of ~600 resolved settings, three differ, and all three are settings that were previously unset and
now resolve to the stock Xcode default for that configuration — `ENABLE_NS_ASSERTIONS=YES` and
`SWIFT_COMPILATION_MODE=singlefile` in Debug, `GCC_OPTIMIZATION_LEVEL=s` in Release. Those were
the effective values before; they were simply not listed. Both configurations build.

Note that `tuist` installed from the Homebrew cask hangs on launch on this machine — it never gets
past dynamic linking, with no output and no CPU use, and it is not Gatekeeper or the quarantine
flag. The same version installed through mise (`mise install tuist`) works, and was used instead.

## Known issues not addressed

- **Dependencies are well behind.** Defaults 7.1.0 → 9.0.9, KeyboardShortcuts 1.10.0 → 3.0.1,
  LaunchAtLogin-Modern 1.0.0 → 1.1.0. All pinned to `exactVersion`. Two are major-version jumps
  with API breaks; deliberately out of scope here.
- **Swift 5 language mode**, no strict concurrency checking, on code that touches `NSApp` from
  Combine sinks. Project format is `objectVersion = 56` (Xcode 14 era).
- **No tests and no linter.** If a shell linter is ever added, `declare -r arch="$(uname -m)"`
  in `scripts/build.bash` will trip ShellCheck SC2155 (declaration and assignment combined masks
  the command's exit status). Kept as-is to match the script's existing style.
- **Version not bumped** — still 1.1.1 (9). That is a release-time decision.
- **Commits on this branch are unsigned.** `commit.gpgsign` is enabled, but signing could not be
  performed from the working environment: `ssh-keygen -Y sign` reported
  `incorrect passphrase supplied to decrypt private key` for `~/.ssh/id_ed25519`, even though
  plain `ssh` authenticates with that same key without any prompt. Worth diagnosing separately;
  `ssh-keygen -Y sign -f ~/.ssh/id_ed25519 -n git /dev/null` will show whether it reproduces
  outside this environment.
