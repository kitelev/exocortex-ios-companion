//
//  URLSchemeHandler.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import Foundation
import SwiftUI

/// Handles parsing and validation of exocortex:// URL scheme
class URLSchemeHandler: ObservableObject {
    
    @Published var lastReceivedTask: TaskModel?
    @Published var errorMessage: String?
    
    /// Parse and validate an incoming URL
    /// - Parameter url: The URL to parse (e.g., exocortex://task/start?taskId=abc&title=...)
    /// - Returns: TaskModel if successful, nil otherwise
    func handle(_ url: URL) -> TaskModel? {
        // Log the incoming URL
        print("📱 Received URL: \(url.absoluteString)")
        
        // Validate scheme
        guard url.scheme?.lowercased() == "exocortex" else {
            setError("Invalid URL scheme. Expected 'exocortex://', got '\(url.scheme ?? "nil")'")
            return nil
        }
        
        // Validate host/path (expecting "task/start" or just "start")
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        guard pathComponents.contains("start") || pathComponents.contains("task") else {
            setError("Invalid URL path. Expected 'exocortex://task/start' or 'exocortex://start'")
            return nil
        }
        
        // Parse query parameters
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            setError("Failed to parse URL query parameters")
            return nil
        }
        
        // Create task model from query parameters
        guard let task = TaskModel(queryItems: queryItems) else {
            setError("Invalid task parameters. Required: taskId, title, startTime (ISO8601)")
            return nil
        }
        
        // Success
        clearError()
        lastReceivedTask = task
        print("✅ Successfully parsed task: \(task.title)")
        return task
    }
    
    /// Validate a URL without creating a TaskModel
    /// - Parameter url: The URL to validate
    /// - Returns: True if URL is valid, false otherwise
    func validate(_ url: URL) -> Bool {
        handle(url) != nil
    }
    
    // MARK: - Error Handling
    
    private func setError(_ message: String) {
        errorMessage = message
        print("❌ URL Parse Error: \(message)")
    }
    
    private func clearError() {
        errorMessage = nil
    }
}

// MARK: - URL Building Helper (for testing)
extension URLSchemeHandler {
    /// Build a test URL for development
    static func buildTestURL(
        taskId: String = "test-123",
        title: String = "Test Task",
        startTime: Date = Date(),
        callbackURL: String? = nil
    ) -> URL {
        var components = URLComponents()
        components.scheme = "exocortex"
        components.host = "task"
        components.path = "/start"
        
        var queryItems = [
            URLQueryItem(name: "taskId", value: taskId),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "startTime", value: ISO8601DateFormatter().string(from: startTime))
        ]
        
        if let callback = callbackURL {
            queryItems.append(URLQueryItem(name: "x-success", value: callback))
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}

// MARK: - Preview Helpers
extension URLSchemeHandler {
    static let preview: URLSchemeHandler = {
        let handler = URLSchemeHandler()
        let testURL = buildTestURL(
            title: "Preview Task: Implement Feature",
            callbackURL: "obsidian://open?vault=MyVault"
        )
        _ = handler.handle(testURL)
        return handler
    }()
}
