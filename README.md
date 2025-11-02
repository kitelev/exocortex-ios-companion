# Exocortex Task Tracker - iOS Companion App

iOS companion app for Exocortex Obsidian plugin that displays Live Activities for task tracking.

## Features

- 📱 Live Activities on iOS lock screen
- 🔗 URL scheme handling (`exocortex://`)
- ☁️ iCloud Drive sync for task persistence
- ⏱️ Real-time task tracking with start time and duration

## Requirements

- iOS 16.1+
- Xcode 14.1+
- Apple Developer Account (for Live Activities capability)

## Project Structure

```
ExocortexTaskTracker/
├── App/
│   ├── ExocortexTaskTrackerApp.swift    # Main app entry point
│   ├── ContentView.swift                 # Main UI view
│   └── Info.plist                        # App configuration with URL scheme
├── Features/
│   ├── TaskTracking/                     # Task management features
│   │   ├── Models/                       # Data models
│   │   └── Views/                        # UI components
│   └── URLHandling/                      # URL scheme parsing
├── Services/                              # Business logic services
└── Resources/
    └── Assets.xcassets/                  # App icons and colors
```

## Setup

1. Open `ExocortexTaskTracker.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Enable capabilities:
   - Push Notifications (for Live Activities)
   - iCloud → iCloud Drive
4. Build and run on a **physical device** (Live Activities don't work in Simulator)

## URL Scheme

The app responds to `exocortex://` URLs from the Obsidian plugin:

```
exocortex://task/start?taskId=abc&title=Task%20Title&startTime=2025-01-01T10:00:00Z&x-success=obsidian://...
```

## Development Status

- [x] Basic project structure created (using XcodeGen)
- [x] URL scheme handler implementation
- [x] Task data models
- [x] Unit tests for URL parsing
- [x] Xcode project properly configured with targets
- [ ] iCloud sync service
- [ ] ActivityKit Live Activity implementation
- [ ] Widget extension with Live Activity UI

### CI Status

[![CI](https://github.com/kitelev/exocortex-ios-companion/actions/workflows/ci.yml/badge.svg)](https://github.com/kitelev/exocortex-ios-companion/actions/workflows/ci.yml)

- ✅ SwiftLint: Passing
- ✅ Build: Passing  
- ✅ Tests: Passing

## Related

- Parent project: [exocortex-obsidian-plugin](https://github.com/kitelev/exocortex-obsidian-plugin)
- Implementation plan: See `IOS_LIVE_ACTIVITIES_IMPLEMENTATION_PLAN.md` in parent project

## License

MIT
