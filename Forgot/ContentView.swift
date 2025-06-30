//
//  ContentView.swift
//  Forgot
//
//  Created by VC on 28/6/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ContentView: View {
    
    var body: some View {
            Home()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ForgotItems.self, inMemory: true)
}
