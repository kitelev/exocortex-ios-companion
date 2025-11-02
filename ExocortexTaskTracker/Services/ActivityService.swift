//
//  ActivityService.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import Foundation
import ActivityKit
import SwiftUI

/// Service for managing Live Activities lifecycle
@available(iOS 16.1, *)
class ActivityService: ObservableObject {
    
    /// Current active activity
    @Published private(set) var currentActivity: Activity<TaskActivityAttributes>?
    
    /// Activity state
    @Published var activityState: ActivityState = .none
    
    enum ActivityState {
        case none
        case active
        case paused
        case completed
    }
    
    // MARK: - Initialization
    
    init() {
        // Check for existing activities on init
        restoreExistingActivity()
    }
    
    // MARK: - Activity Lifecycle
    
    /// Start a new Live Activity
    /// - Parameters:
    ///   - taskId: Unique task identifier
    ///   - taskTitle: Task title
    ///   - startTime: Task start time
    /// - Returns: True if activity started successfully
    @discardableResult
    func startActivity(taskId: String, taskTitle: String, startTime: Date) async -> Bool {
        // Check authorization
        let authorizationStatus = ActivityAuthorizationInfo().areActivitiesEnabled
        guard authorizationStatus else {
            print("❌ Live Activities are not enabled by user")
            return false
        }
        
        // End existing activity if any
        if let existing = currentActivity {
            await endActivity(existing)
        }
        
        // Create attributes
        let attributes = TaskActivityAttributes(taskId: taskId)
        let contentState = TaskActivityAttributes.ContentState.initial(
            taskTitle: taskTitle,
            startTime: startTime
        )
        
        // Request activity
        do {
            let activity = try Activity<TaskActivityAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            
            await MainActor.run {
                self.currentActivity = activity
                self.activityState = .active
            }
            
            print("✅ Live Activity started: \(taskTitle)")
            return true
            
        } catch {
            print("❌ Failed to start Live Activity: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Update activity state
    /// - Parameter newState: New content state
    func updateActivity(with newState: TaskActivityAttributes.ContentState) async {
        guard let activity = currentActivity else {
            print("⚠️ No active activity to update")
            return
        }
        
        await activity.update(using: newState)
        
        await MainActor.run {
            self.activityState = switch newState.status {
            case .active: .active
            case .paused: .paused
            case .completed: .completed
            }
        }
        
        print("✅ Activity updated: \(newState.status.rawValue)")
    }
    
    /// Pause current activity
    func pauseActivity() async {
        guard let activity = currentActivity else { return }
        
        let pausedState = activity.contentState.paused()
        await updateActivity(with: pausedState)
    }
    
    /// Resume current activity
    func resumeActivity() async {
        guard let activity = currentActivity else { return }
        
        let resumedState = activity.contentState.resumed()
        await updateActivity(with: resumedState)
    }
    
    /// Complete current activity
    func completeActivity() async {
        guard let activity = currentActivity else { return }
        
        let completedState = activity.contentState.completed()
        await updateActivity(with: completedState)
        
        // End activity after a delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        await endActivity(activity)
    }
    
    /// End activity
    /// - Parameter activity: Activity to end
    private func endActivity(_ activity: Activity<TaskActivityAttributes>) async {
        await activity.end(
            using: activity.contentState,
            dismissalPolicy: .immediate
        )
        
        await MainActor.run {
            self.currentActivity = nil
            self.activityState = .none
        }
        
        print("✅ Live Activity ended")
    }
    
    /// End current activity
    func endCurrentActivity() async {
        guard let activity = currentActivity else { return }
        await endActivity(activity)
    }
    
    // MARK: - Activity Recovery
    
    /// Restore existing activity if app was killed
    private func restoreExistingActivity() {
        let activities = Activity<TaskActivityAttributes>.activities
        
        if let existingActivity = activities.first {
            currentActivity = existingActivity
            activityState = switch existingActivity.contentState.status {
            case .active: .active
            case .paused: .paused
            case .completed: .completed
            }
            
            print("✅ Restored existing Live Activity")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Check if Live Activities are available and enabled
    static func areActivitiesEnabled() -> Bool {
        if #available(iOS 16.1, *) {
            return ActivityAuthorizationInfo().areActivitiesEnabled
        }
        return false
    }
    
    /// Check if there's an active activity
    var hasActiveActivity: Bool {
        currentActivity != nil
    }
}
