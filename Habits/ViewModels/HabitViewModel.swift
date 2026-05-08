//
//  HabitViewModel.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import Foundation
import Observation
import CoreLocation
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

    @discardableResult
    func incrementCompletion(for habit: Habit, on date: Date) -> Completion? {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)

        if let completion = habit.completions.first(where: {
            calendar.isDate($0.date, inSameDayAs: day)
        }) {
            if completion.numberOfTimesDone < habit.targetPerDay {
                completion.numberOfTimesDone += 1
                return completion
            } else {
                completion.numberOfTimesDone = 0
                habit.completions.removeAll {
                    calendar.isDate($0.date, inSameDayAs: day)
                }
                return nil
            }

        } else {
            let completion = Completion(date: day)
            habit.completions.append(completion)
            return completion
        }
    }

    @discardableResult
    func incrementCompletionToday(for habit: Habit) -> Completion? {
        return incrementCompletion(for: habit, on: Date())
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

    func addLocation(_ location: CLLocation?, to completion: Completion) {
        guard let location else { return }
        completion.latitude = location.coordinate.latitude
        completion.longitude = location.coordinate.longitude
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
