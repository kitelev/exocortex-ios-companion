//
//  URLSchemeHandlerTests.swift
//  ExocortexTaskTrackerTests
//
//  Created by AI on 2025-11-02.
//

import XCTest
@testable import ExocortexTaskTracker

final class URLSchemeHandlerTests: XCTestCase {
    
    var handler: URLSchemeHandler!
    
    override func setUp() {
        super.setUp()
        handler = URLSchemeHandler()
    }
    
    override func tearDown() {
        handler = nil
        super.tearDown()
    }
    
    // MARK: - Valid URL Tests
    
    func testValidURLParsing() {
        // Given
        let url = URLSchemeHandler.buildTestURL(
            taskId: "task-123",
            title: "Test Task Title",
            startTime: Date(),
            callbackURL: "obsidian://open?vault=MyVault"
        )
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNotNil(task, "Task should be created from valid URL")
        XCTAssertEqual(task?.id, "task-123")
        XCTAssertEqual(task?.title, "Test Task Title")
        XCTAssertNotNil(task?.callbackURL)
    }
    
    func testURLWithSpecialCharactersInTitle() {
        // Given
        let url = URLSchemeHandler.buildTestURL(
            title: "Task: Complete iOS 📱 Implementation!"
        )
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNotNil(task)
        XCTAssertTrue(task?.title.contains("iOS") ?? false)
        XCTAssertTrue(task?.title.contains("📱") ?? false)
    }
    
    func testURLWithoutCallback() {
        // Given
        let url = URLSchemeHandler.buildTestURL(callbackURL: nil)
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNotNil(task)
        XCTAssertNil(task?.callbackURL)
    }
    
    // MARK: - Invalid URL Tests
    
    func testInvalidScheme() {
        // Given
        var components = URLComponents()
        components.scheme = "https" // Wrong scheme
        components.host = "task"
        components.path = "/start"
        components.queryItems = [
            URLQueryItem(name: "taskId", value: "123"),
            URLQueryItem(name: "title", value: "Test"),
            URLQueryItem(name: "startTime", value: ISO8601DateFormatter().string(from: Date()))
        ]
        let url = components.url!
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNil(task)
        XCTAssertNotNil(handler.errorMessage)
    }
    
    func testMissingRequiredParameters() {
        // Given - missing title
        var components = URLComponents()
        components.scheme = "exocortex"
        components.host = "task"
        components.path = "/start"
        components.queryItems = [
            URLQueryItem(name: "taskId", value: "123"),
            URLQueryItem(name: "startTime", value: ISO8601DateFormatter().string(from: Date()))
        ]
        let url = components.url!
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNil(task)
        XCTAssertNotNil(handler.errorMessage)
    }
    
    func testInvalidDateFormat() {
        // Given
        var components = URLComponents()
        components.scheme = "exocortex"
        components.host = "task"
        components.path = "/start"
        components.queryItems = [
            URLQueryItem(name: "taskId", value: "123"),
            URLQueryItem(name: "title", value: "Test"),
            URLQueryItem(name: "startTime", value: "invalid-date")
        ]
        let url = components.url!
        
        // When
        let task = handler.handle(url)
        
        // Then
        XCTAssertNil(task)
        XCTAssertNotNil(handler.errorMessage)
    }
    
    // MARK: - Task Model Tests
    
    func testTaskModelCreation() {
        // Given
        let queryItems = [
            URLQueryItem(name: "taskId", value: "abc"),
            URLQueryItem(name: "title", value: "My Task"),
            URLQueryItem(name: "startTime", value: "2025-01-01T10:00:00Z")
        ]
        
        // When
        let task = TaskModel(queryItems: queryItems)
        
        // Then
        XCTAssertNotNil(task)
        XCTAssertEqual(task?.id, "abc")
        XCTAssertEqual(task?.title, "My Task")
        XCTAssertEqual(task?.status, .active)
    }
    
    func testTaskDuration() {
        // Given
        let pastTime = Date().addingTimeInterval(-3600) // 1 hour ago
        let task = TaskModel(
            id: "test",
            title: "Test",
            startTime: pastTime,
            callbackURL: nil
        )
        
        // When
        let duration = task.duration
        
        // Then
        XCTAssertGreaterThan(duration, 3500) // ~1 hour
        XCTAssertLessThan(duration, 3700)
    }
}
