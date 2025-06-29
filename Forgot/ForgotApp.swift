//
//  ForgotApp.swift
//  Forgot
//
//  Created by VC on 28/6/2025.
//

import SwiftUI
import SwiftData

@main
struct ForgotApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ForgotItems.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
