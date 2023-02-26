import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

extension KeyboardShortcuts.Name {
	static let centerMousePointer = Self("centerMousePointer")
}

struct SettingsView: View {
	var body: some View {
		Form {
			LabeledContent("Behavior:") {
				LaunchAtLogin.Toggle()
			}
			Defaults.Toggle("Move mouse to center on system events", key: .monitorSystemEvents)
			Group {
				Text("System events include:")
				Text("\u{2022}  Waking from sleep")
				Text("\u{2022}  Locking the screen")
				Text("\u{2022}  Unlocking the screen")
				Text("\u{2022}  Exiting the screen saver")
			}.settingDescription()

			LabeledContent("Keyboard Shortcut:") {
				KeyboardShortcuts.Recorder(for: .centerMousePointer)
			}
			Text("Define a global keyboard shortcut to move the mouse")
				.settingDescription()

			LabeledContent("User Interface:") {
				Defaults.Toggle("Hide Dock icon", key: .hideDockIcon)
			}
			Text(#"When the Dock icon is hidden, CenterMouse will run in "headless" mode. You can safely close this window, and the app will continue to run in the background."#)
				.settingDescription()

			VStack(alignment: .trailing) {
				HStack {
					Spacer()
					Button("About") {
						NSApp.orderFrontStandardAboutPanel(
							options: [
								.applicationIcon: NSWorkspace.shared.icon(forFile: Bundle.main.bundlePath),
								.credits: LocalizedStrings.credits
							]
						)
					}
					Button("Quit") {
						NSApp.terminate(nil)
					}
				}
			}
		}
		.frame(width: 480, height: 300)
		.padding([.leading, .trailing], 40)
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}

extension View {
	/// Applies font and color for a label used for describing a setting.
	public func settingDescription() -> some View {
		font(.system(size: 11.0))
			.foregroundStyle(.secondary)
	}
}
