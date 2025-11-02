//
//  TaskModel.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import Foundation

/// Task data model representing a task from Obsidian
struct TaskModel: Codable, Identifiable, Equatable {
    let id: String // taskId from URL
    let title: String
    let startTime: Date
    let callbackURL: URL? // x-success URL for returning to Obsidian
    
    /// Current status of the task
    var status: TaskStatus = .active
    
    /// Duration since start (computed property)
    var duration: TimeInterval {
        Date().timeIntervalSince(startTime)
    }
    
    enum TaskStatus: String, Codable {
        case active
        case paused
        case completed
    }
}

// MARK: - Convenience Initializers
extension TaskModel {
    /// Create a task from URL query parameters
    init?(queryItems: [URLQueryItem]) {
        // Required: taskId
        guard let taskId = queryItems.first(where: { $0.name == "taskId" })?.value,
              !taskId.isEmpty else {
            return nil
        }
        
        // Required: title
        guard let title = queryItems.first(where: { $0.name == "title" })?.value,
              !title.isEmpty else {
            return nil
        }
        
        // Required: startTime (ISO8601 format)
        guard let startTimeString = queryItems.first(where: { $0.name == "startTime" })?.value,
              let startTime = ISO8601DateFormatter().date(from: startTimeString) else {
            return nil
        }
        
        // Optional: x-success callback URL
        let callbackURLString = queryItems.first(where: { $0.name == "x-success" })?.value
        let callbackURL = callbackURLString.flatMap { URL(string: $0) }
        
        self.id = taskId
        self.title = title
        self.startTime = startTime
        self.callbackURL = callbackURL
        self.status = .active
    }
}

// MARK: - Sample Data for Previews
extension TaskModel {
    static let sample = TaskModel(
        id: "abc123",
        title: "Complete iOS Live Activities Implementation",
        startTime: Date().addingTimeInterval(-3600), // 1 hour ago
        callbackURL: URL(string: "obsidian://open?vault=MyVault&file=Tasks")
    )
    
    static let sampleWithoutCallback = TaskModel(
        id: "xyz789",
        title: "Review Pull Requests",
        startTime: Date(),
        callbackURL: nil
    )
}
