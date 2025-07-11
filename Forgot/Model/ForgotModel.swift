//
//  ForgotModel.swift
//  Forgot
//
//  Created by VC on 29/6/2025.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class ForgotItems {
    var id: String
    var timestamp: Date
    var task: String
    var isCompleted: Bool
    var priority: Priority
    
    init(timestamp: Date, task: String) {
        self.id = UUID().uuidString
        self.timestamp = timestamp
        self.task = task
        self.isCompleted = false
        self.priority = Priority.low
    }
}

enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color{
        switch self {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
}
