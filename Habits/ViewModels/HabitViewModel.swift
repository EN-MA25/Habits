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
            note: cleanedNote.isEmpty ? nil : cleanedNote
        )

        context.insert(habit)
    }

    func deleteHabit(_ habit: Habit, context: ModelContext) {
        context.delete(habit)
    }
    
    func incrementCompletion(for habit: Habit, on date: Date) {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)
        
        if let completion = habit.completions.first(where: {
            calendar.isDate($0.date, inSameDayAs: day)
        }) {
            if completion.count < habit.targetPerDay {
                completion.count += 1
            } else {
                completion.count = 0
                habit.completions.removeAll {
                    calendar.isDate($0.date, inSameDayAs: day)
                }
            }
        } else {
            habit.completions.append(Completion(date: day))
        }
    }
    
    func incrementCompletionToday(for habit: Habit) {
        incrementCompletion(for: habit, on: Date())
    }
    
    func decrementCompletion(for habit: Habit, on date: Date) {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)

        guard let completion = habit.completions.first(where: {
            calendar.isDate($0.date, inSameDayAs: day)
        }) else { return }

        completion.count -= 1

        if completion.count <= 0 {
            habit.completions.removeAll {
                calendar.isDate($0.date, inSameDayAs: day)
            }
        }
    }
    
    func decrementCompletionToday(for habit: Habit) {
        decrementCompletion(for: habit, on: Date())
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

    //TODO: - Test method. In production it should not be used
    func toggleCompletion(for habit: Habit, atDate date: Date) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)

        if let index = habit.completions.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: normalizedDate)
        }) {
            habit.completions.remove(at: index)
        } else {
            habit.completions.append(Completion(date: normalizedDate))
        }
    }

}
