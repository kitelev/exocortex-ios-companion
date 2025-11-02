//
//  ContentView.swift
//  ExocortexTaskTracker
//
//  Created by AI on 2025-11-02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Exocortex Task Tracker")
                .font(.title)
                .padding()
            Text("Ready to track your tasks with Live Activities!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
