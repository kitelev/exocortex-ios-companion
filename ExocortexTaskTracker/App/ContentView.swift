//
//  ContentView.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var urlHandler: URLSchemeHandler
    @EnvironmentObject var activityService: ActivityService
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))
            
            Text("Exocortex Task Tracker")
                .font(.title)
                .fontWeight(.bold)
            
            // Live Activity Status
            if #available(iOS 16.1, *) {
                LiveActivityStatusView()
            }
            
            if let task = urlHandler.lastReceivedTask {
                // Show received task
                VStack(spacing: 12) {
                    Text("Active Task:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    TaskCardView(task: task)
                    
                    // Activity control buttons
                    if #available(iOS 16.1, *), activityService.hasActiveActivity {
                        HStack(spacing: 16) {
                            Button(action: {
                                Task {
                                    await activityService.pauseActivity()
                                }
                            }) {
                                Label("Pause", systemImage: "pause.circle")
                            }
                            
                            Button(action: {
                                Task {
                                    await activityService.completeActivity()
                                }
                            }) {
                                Label("Complete", systemImage: "checkmark.circle")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            } else {
                // No task yet
                Text("Ready to track your tasks with Live Activities!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Open a task URL from Obsidian to start tracking.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            if let error = urlHandler.errorMessage {
                Text("Error: \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

/// Live Activity Status indicator
@available(iOS 16.1, *)
struct LiveActivityStatusView: View {
    @EnvironmentObject var activityService: ActivityService
    
    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var statusColor: Color {
        switch activityService.activityState {
        case .none: return .gray
        case .active: return .green
        case .paused: return .orange
        case .completed: return .blue
        }
    }
    
    private var statusText: String {
        switch activityService.activityState {
        case .none: return "No Live Activity"
        case .active: return "Live Activity Active"
        case .paused: return "Live Activity Paused"
        case .completed: return "Live Activity Completed"
        }
    }
}

/// Simple task card view
struct TaskCardView: View {
    let task: TaskModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.headline)
            
            HStack {
                Label("Started", systemImage: "clock")
                Text(task.startTime, style: .relative)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            if let callback = task.callbackURL {
                Label("Callback configured", systemImage: "checkmark.circle")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .environmentObject(URLSchemeHandler.preview)
}
