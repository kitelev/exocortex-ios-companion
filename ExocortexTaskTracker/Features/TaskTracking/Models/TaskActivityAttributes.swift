//
//  TaskActivityAttributes.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import Foundation
import ActivityKit

/// ActivityAttributes for Task tracking Live Activity
struct TaskActivityAttributes: ActivityAttributes {
    public typealias TaskStatus = ContentState.TaskStatus
    
    /// Static attributes that don't change during the activity lifecycle
    public struct ContentState: Codable, Hashable {
        /// Current task title
        var taskTitle: String
        
        /// Task start time
        var startTime: Date
        
        /// Current status
        var status: TaskStatus
        
        /// Task status enum
        enum TaskStatus: String, Codable, Hashable {
            case active = "Active"
            case paused = "Paused"
            case completed = "Completed"
        }
        
        /// Duration since start (computed)
        var duration: TimeInterval {
            Date().timeIntervalSince(startTime)
        }
        
        /// Formatted duration string
        var formattedDuration: String {
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60
            let seconds = Int(duration) % 60
            
            if hours > 0 {
                return String(format: "%d:%02d:%02d", hours, minutes, seconds)
            } else {
                return String(format: "%d:%02d", minutes, seconds)
            }
        }
    }
    
    /// Unique task identifier (immutable)
    var taskId: String
}

// MARK: - Convenience Extensions
extension TaskActivityAttributes.ContentState {
    /// Create initial content state from task
    static func initial(taskTitle: String, startTime: Date) -> Self {
        TaskActivityAttributes.ContentState(
            taskTitle: taskTitle,
            startTime: startTime,
            status: .active
        )
    }
    
    /// Create paused state
    func paused() -> Self {
        var state = self
        state.status = .paused
        return state
    }
    
    /// Create completed state
    func completed() -> Self {
        var state = self
        state.status = .completed
        return state
    }
    
    /// Create resumed state
    func resumed() -> Self {
        var state = self
        state.status = .active
        return state
    }
}
