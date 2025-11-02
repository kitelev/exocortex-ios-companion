# XcodeGen Configuration

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project file.

## Why XcodeGen?

- ✅ Easier to manage project structure in YAML
- ✅ Better for CI/CD and code generation
- ✅ Avoids merge conflicts in .pbxproj files
- ✅ Reproducible project configuration

## Usage

### Regenerate Xcode Project

If you add/remove files or change project settings:

```bash
xcodegen generate
```

### Configuration

Project configuration is defined in `project.yml` (not tracked in git, generated from structure).

To modify the project:
1. Edit source files directly
2. Run `xcodegen generate`
3. Commit the generated `.xcodeproj`

### Installing XcodeGen

```bash
brew install xcodegen
```

## Project Structure

The generator automatically discovers:
- All `.swift` files in `ExocortexTaskTracker/`
- All `.swift` files in `ExocortexTaskTrackerTests/`
- Resources in `ExocortexTaskTracker/Resources/`
- Info.plist in `ExocortexTaskTracker/App/`

## CI Integration

GitHub Actions CI automatically uses the generated project without needing XcodeGen installed.
