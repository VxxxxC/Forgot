//
//  ForgotModel.swift
//  Forgot
//
//  Created by VC on 29/6/2025.
//

import Foundation
import SwiftData

@Model
final class ForgotItems {
    var timestamp: Date
    var task: String = ""
    
    init(timestamp: Date, task: String) {
        self.timestamp = timestamp
        self.task = task
    }
    
}
