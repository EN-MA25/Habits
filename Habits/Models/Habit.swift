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
    var name: String
    var timestamp: Date
    var completions: [Completion] = []
    
    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

extension Habit {
    func isCompletedToday() -> Bool {
        completions.contains {
            Calendar.current.isDateInToday($0.date)
        }
    }
}
