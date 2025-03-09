# CenterMouse Development Guide

## Build Commands
- `make build` - Build the project using xcodebuild and xcbeautify
- `make clean` - Remove the DerivedData directory
- `xcrun xcodebuild -scheme "CenterMouse" -derivedDataPath "DerivedData" build` - Direct build command

## Code Style Guidelines
- **Access Control**: Use `private` for implementation details
- **Classes**: Prefer `final class` for non-inheritance classes
- **Imports**: Group imports alphabetically (AppKit, Cocoa, Defaults, SwiftUI)
- **Indentation**: 1 tab (not spaces) for indentation
- **Naming**: Use descriptive camelCase names (variables/functions), PascalCase (types)
- **Documentation**: Add comments for non-obvious functionality
- **Error Handling**: Use guard statements for early returns
- **SwiftUI**: Use SwiftUI for UI components, AppKit for system integration
- **Dependencies**: Uses Defaults package for preferences management
- **Formatting**: Multiline parameters/conditions aligned with first parameter/condition

## Project Structure
- `/CenterMouse/Sources` - Swift source files
- `/CenterMouse/Resources` - Assets, XIBs, and config files
- `/scripts` - Build scripts