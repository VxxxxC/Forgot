//
//  Item.swift
//  Forgot
//
//  Created by VC on 28/6/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var text: String = ""
    
    init(timestamp: Date, text: String) {
        self.timestamp = timestamp
        self.text = text
    }
}
