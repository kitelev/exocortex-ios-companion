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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(urlHandler)
                .onOpenURL { url in
                    print("🔗 App opened with URL: \(url.absoluteString)")
                    if let task = urlHandler.handle(url) {
                        print("✅ Task received: \(task.title)")
                        // Task will be available via urlHandler.lastReceivedTask
                    } else if let error = urlHandler.errorMessage {
                        print("❌ Error parsing URL: \(error)")
                    }
                }
        }
    }
}
