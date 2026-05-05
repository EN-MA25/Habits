//
//  HabitViewModel.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftData
import Foundation
import Observation

@Observable
class HabitViewModel {

    func addHabit(name: String, context: ModelContext) {
        let habit = Habit(name: name, timestamp: Date())
        context.insert(habit)
    }
    
    func deleteHabit(_ habit: Habit, context: ModelContext) {
        context.delete(habit)
    }
    
}
