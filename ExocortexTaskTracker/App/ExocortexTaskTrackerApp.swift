//
//  ExocortexTaskTrackerApp.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import SwiftUI

@main
struct ExocortexTaskTrackerApp: App {
    @StateObject private var urlHandler = URLSchemeHandler()
    @StateObject private var activityService: ActivityService = {
        if #available(iOS 16.1, *) {
            return ActivityService()
        } else {
            fatalError("iOS 16.1+ required for Live Activities")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(urlHandler)
                .environmentObject(activityService)
                .onOpenURL { url in
                    print("🔗 App opened with URL: \(url.absoluteString)")
                    if let task = urlHandler.handle(url) {
                        print("✅ Task received: \(task.title)")
                        
                        // Start Live Activity when task is received
                        if #available(iOS 16.1, *) {
                            Task {
                                await activityService.startActivity(
                                    taskId: task.id,
                                    taskTitle: task.title,
                                    startTime: task.startTime
                                )
                            }
                        }
                    } else if let error = urlHandler.errorMessage {
                        print("❌ Error parsing URL: \(error)")
                    }
                }
        }
    }
}
