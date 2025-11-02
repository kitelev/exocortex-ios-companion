//
//  ContentView.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var urlHandler: URLSchemeHandler
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))
            
            Text("Exocortex Task Tracker")
                .font(.title)
                .fontWeight(.bold)
            
            if let task = urlHandler.lastReceivedTask {
                // Show received task
                VStack(spacing: 12) {
                    Text("Active Task:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    TaskCardView(task: task)
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
