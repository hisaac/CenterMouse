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

## Dead code removal

- **`Font.swift` (150 lines)** — a vendored set of `NSFont` convenience extensions, of which
  exactly two were used: `NSFont.title3` and `NSFont.headline.boldAndItalic()`. Both are now
  computed inline in `LocalizedStrings`, and the file is gone.
- **`Extensions.swift`** — existed only so the credits could pass string literals where `URL`
  was expected. It declared a retroactive conformance of `Foundation.URL` to
  `ExpressibleByStringLiteral`, which was the source of the only compiler warning in the
  project. Removed; the credits now use `String` link values throughout, which
  `NSAttributedString.Key.link` accepts natively and which the "More info" link was already
  relying on.
- **The "Print Build Settings to Log" build phase** — ran `export` and was marked always-out-of-date,
  forcing a script phase to run on every single build for output nobody was reading.
- **Assorted** — a `deinit` that duplicated what `Set<AnyCancellable>` already does on
  deallocation, a `link:` parameter on `creditedPerson` that no call site ever passed, and two
  notification names (`screensaver.didstart` / `didstop`) that were declared but unused because
  they are never delivered. The knowledge that they don't work is preserved as a comment.
- **`print()` → `OSLog`** — the app logged to stdout in release builds. Now uses a `Logger` with
  the bundle identifier as subsystem.

Net effect on the app target: **−160 lines**, and the build is now free of project-owned warnings.

## Build tooling

### Xcode pin was inert

`mise.toml` pinned Xcode `26.5.0`, which is not installed. Every build printed
`No Xcode installation matching version 26.5.0 was found` and left `DEVELOPER_DIR` unset, so the
pin did nothing and builds silently used whatever `xcode-select` pointed at — locally and in CI.
Bumped to `26.6.0`, the installed version. `DEVELOPER_DIR` now correctly resolves to
`/Applications/Xcode-26.6.0.app/Contents/Developer`, so the pin actually pins.

The plugin's `matches_fuzzy` compares only as many version components as you write, so `26.6`
would work identically; three components were used to match the file's existing style.

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

## Known issues not addressed

- **The About panel is inconsistent.** The "About" button in the settings window calls
  `orderFrontStandardAboutPanel(options:)` with credits and an icon. The "About CenterMouse"
  item in the menu bar is wired in `MainMenu.xib` to the standard `orderFrontStandardAboutPanel:`
  action with *no* options, so it shows a bare panel with no credits at all. Two different
  About experiences depending on how you get there. Fixing this means either pointing the menu
  item at an app delegate action or dropping the credits.
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
