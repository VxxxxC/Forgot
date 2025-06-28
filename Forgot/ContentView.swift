//
//  ContentView.swift
//  Forgot
//
//  Created by VC on 28/6/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        
        TabView {
            ForgotTab().tabItem{
                Image(systemName: "list.bullet")
                Text("Forgot List")
            }
            Setting().tabItem{
                Image(systemName: "gear")
                Text("Setting")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
