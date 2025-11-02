# Live Activities Setup Instructions

## ⚠️ Important: Manual Configuration Required

After pulling this branch, you need to configure Push Notifications capability in Xcode.

### Steps:

1. **Open project in Xcode**:
   ```bash
   open ExocortexTaskTracker.xcodeproj
   ```

2. **Enable Push Notifications**:
   - Select the `ExocortexTaskTracker` target
   - Go to "Signing & Capabilities" tab
   - Click "+" button (top left)
   - Add "Push Notifications"
   - This capability is required for Live Activities

3. **Build on Physical Device**:
   - ⚠️ Live Activities do NOT work in Simulator
   - Connect iPhone/iPad (iOS 16.1+)
   - Select device in Xcode
   - Build and Run (⌘R)

4. **Grant Permissions**:
   - When app launches first time, it may prompt for Live Activities permission
   - Grant permission

5. **Test Live Activity**:
   ```bash
   # In Safari on iPhone, open this URL:
   exocortex://task/start?taskId=test-123&title=Test%20Task&startTime=2025-11-02T10:00:00Z
   ```

6. **Lock iPhone**:
   - Press power button to lock screen
   - Live Activity should appear on lock screen!

## Troubleshooting

### Live Activity not showing?

1. Check Settings → ExocortexTaskTracker → Enable "Live Activities"
2. Make sure you're on a physical device (not Simulator)
3. Check Xcode console for error messages
4. Try deleting app and reinstalling

### Permission denied?

- Delete app completely
- Reinstall
- Grant permission when prompted

## Features Implemented

- ✅ TaskActivityAttributes - Activity data model
- ✅ ActivityService - Lifecycle management  
- ✅ Auto-start activity when task URL is received
- ✅ Pause/Resume/Complete controls
- ✅ Activity status indicator in app
- ✅ iOS 16.1+ availability checks
- ✅ Single activity limit (ends existing before starting new)

## What's Missing

- Widget UI for Live Activity (requires Widget Extension target)
- iCloud persistence (Issue #275)
- Push notification updates

## Next Steps

After confirming Live Activities work:
- Add Widget Extension with custom UI
- Implement activity UI with timer
- Add Dynamic Island support (iOS 16.2+)
