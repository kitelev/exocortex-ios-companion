# CI/CD Documentation

## GitHub Actions Workflows

### CI Workflow (`ci.yml`)

Runs on every push and pull request to `main` branch.

#### Jobs:

1. **SwiftLint** (Linting)
   - Runs SwiftLint with strict mode
   - Enforces code style consistency
   - Configuration: `.swiftlint.yml`

2. **Build and Test**
   - Xcode 15.4 on macOS 14
   - Builds for iOS Simulator (iPhone 15, iOS 17.5)
   - Runs unit tests
   - Uploads test results as artifacts

#### Configuration Files:

- `.github/workflows/ci.yml` - Main CI workflow
- `.swiftlint.yml` - SwiftLint rules configuration
- `Gemfile` - Ruby dependencies (xcpretty)

## Local Development

### Running SwiftLint locally:

```bash
# Install SwiftLint
brew install swiftlint

# Run linting
swiftlint

# Auto-fix issues
swiftlint --fix
```

### Running Tests locally:

```bash
# Open in Xcode
open ExocortexTaskTracker.xcodeproj

# Run tests: Cmd+U
# Or via command line:
xcodebuild test \
  -project ExocortexTaskTracker.xcodeproj \
  -scheme ExocortexTaskTracker \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Requirements

- macOS 14+
- Xcode 15.4+
- SwiftLint
- Ruby (for xcpretty)
