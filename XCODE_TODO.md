# Xcode Project Configuration TODO

## ⚠️ Test Target Not Configured

The Xcode project (`ExocortexTaskTracker.xcodeproj`) needs to be opened in Xcode to properly configure:

### Required Actions:

1. **Open project in Xcode**:
   ```bash
   open ExocortexTaskTracker.xcodeproj
   ```

2. **Add source files to target**:
   - Select all `.swift` files in `ExocortexTaskTracker/Features/`
   - Check "Target Membership" → `ExocortexTaskTracker` in Inspector

3. **Create Test Target**:
   - File → New → Target
   - Choose "Unit Testing Bundle"
   - Name: `ExocortexTaskTrackerTests`
   - Language: Swift
   - Add test files from `ExocortexTaskTrackerTests/` directory

4. **Link test target to app target**:
   - In test target settings
   - Add `ExocortexTaskTracker` to "Target Dependencies"

5. **Verify build**:
   - Product → Build (⌘B)
   - Product → Test (⌘U)

### Current Status:

- ✅ Swift source files exist
- ✅ Test files exist
- ❌ Files not added to Xcode project
- ❌ Test target not created

### CI Workaround:

Currently CI only runs:
- ✅ SwiftLint (passing)
- ✅ Build (passing)
- ⚠️ Tests (skipped until test target configured)

## Why This Happened:

Xcode project files (`.pbxproj`) are binary-like format that's fragile to edit manually. 
They should be modified through Xcode GUI to ensure proper references and UUIDs.

## Alternative: Manual pbxproj Editing

If Xcode is not available, the `project.pbxproj` file needs extensive manual editing to:
1. Add PBXFileReference entries for each Swift file
2. Add PBXBuildFile entries
3. Add files to PBXGroup
4. Add to PBXSourcesBuildPhase
5. Create PBXNativeTarget for tests
6. Link test target to app target

This is error-prone and not recommended.
