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

    func addHabit(
        name: String,
        targetPerDay: Int = 1,
        note: String,
        context: ModelContext,
        enabled: Bool = false,
        reminderTime: Date
    ) {

        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: reminderTime)
        let minute = calendar.component(.minute, from: reminderTime)

        let habit = Habit(
            name: cleanedName,
            note: cleanedNote.isEmpty ? nil : cleanedNote,
            targetPerDay: targetPerDay,
            notificationsEnabled: enabled,
            notificationHour: hour,
            notificationMinute: minute
        )

        context.insert(habit)

        if enabled {
            NotificationManager.shared.scheduleNextReminder(for: habit)
        }
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
            if completion.numberOfTimesDone < habit.targetPerDay {
                completion.numberOfTimesDone += 1
            } else {
                completion.numberOfTimesDone = 0
                habit.completions.removeAll {
                    calendar.isDate($0.date, inSameDayAs: day)
                }
            }
        } else {
            habit.completions.append(Completion(date: day))
        }
        if habit.isCompletedToday, habit.notificationsEnabled {
            NotificationManager.shared.scheduleNextReminder(for: habit)
        }
    }

    func incrementCompletionToday(for habit: Habit) {
        incrementCompletion(for: habit, on: Date())
    }

    func decrementCompletion(for habit: Habit, on date: Date) {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)

        guard
            let completion = habit.completions.first(where: {
                calendar.isDate($0.date, inSameDayAs: day)
            })
        else { return }

        completion.numberOfTimesDone -= 1

        if completion.numberOfTimesDone <= 0 {
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

    func setNotificationEnabled(_ enabled: Bool, for habit: Habit) async -> Bool
    {
        if enabled {
            let granted = await NotificationManager.shared
                .notificationPermissionGranted()
            if granted {
                habit.notificationsEnabled = true
                NotificationManager.shared.scheduleNextReminder(for: habit)
                return true
            } else {
                habit.notificationsEnabled = false
                NotificationManager.shared.cancelReminder(for: habit)
                return false
            }
        } else {
            habit.notificationsEnabled = false
            NotificationManager.shared.cancelReminder(for: habit)
            return true
        }
    }

    func setNotificationTime(_ date: Date, for habit: Habit) {
        let calendar = Calendar.current

        habit.notificationHour = calendar.component(.hour, from: date)
        habit.notificationMinute = calendar.component(.minute, from: date)

        if habit.notificationsEnabled {
            NotificationManager.shared.scheduleNextReminder(for: habit)
        }
    }

}
