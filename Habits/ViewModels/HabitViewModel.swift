//
//  HabitViewModel.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import Foundation
import Observation
import SwiftData

@Observable
class HabitViewModel {

    func addHabit(name: String, note: String, context: ModelContext) {
        
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let habit = Habit(
            name: cleanedName,
            note: cleanedNote.isEmpty ? nil : cleanedNote)
        
        context.insert(habit)
    }

    func deleteHabit(_ habit: Habit, context: ModelContext) {
        context.delete(habit)
    }

    func toggleCompletion(for habit: Habit) {
        let today = Calendar.current.startOfDay(for: Date())

        if let index = habit.completions.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            habit.completions.remove(at: index)
        } else {
            habit.completions.append(Completion(date: today))
        }
    }

}
