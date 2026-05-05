//
//  Habit.swift
//  Habits
//
//  Created by Erik on 2026-05-04.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
