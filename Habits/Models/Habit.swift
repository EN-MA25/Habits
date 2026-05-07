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
    @Attribute(.unique) var name: String

    var note: String?
    var createdAt: Date
    var completions: [Completion]
    var targetPerDay: Int

    init(name: String, note: String? = nil, targetPerDay: Int = 1) {
        self.name = name
        self.note = note
        self.createdAt = Date()
        self.completions = []
        self.targetPerDay = targetPerDay
    }
}

extension Habit {

    func hasCompletion(on date: Date) -> Bool {
        completions.contains {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    var isCompletedToday: Bool {
        isCompleted(on: Date())
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let days = Set(
            completions.map {
                calendar.startOfDay(for: $0.date)
            }
        )

        let startDate: Date
        if days.contains(today) {
            startDate = today
        } else if let yesterday = calendar.date(
            byAdding: .day,
            value: -1,
            to: today
        ),
            days.contains(yesterday)
        {
            startDate = yesterday
        } else {
            return 0
        }

        var streak = 0
        var currentDate = startDate

        while days.contains(currentDate) {
            streak += 1
            guard
                let previousDay = calendar.date(
                    byAdding: .day,
                    value: -1,
                    to: currentDate
                )
            else {
                break
            }

            currentDate = previousDay
        }

        return streak
    }

    var maxStreak: Int {
        let calendar = Calendar.current

        let sortedDays =
            completions
            .map { calendar.startOfDay(for: $0.date) }
            .sorted()

        var maxStreak = 0
        var currentStreak = 0
        var previousDate: Date?

        for date in sortedDays {
            if let prev = previousDate,
                calendar.date(byAdding: .day, value: 1, to: prev) == date
            {
                currentStreak += 1
            } else {
                currentStreak = 1
            }

            maxStreak = max(maxStreak, currentStreak)
            previousDate = date
        }

        return maxStreak
    }
    
    func numberOfTimesDone(on date: Date) -> Int {
        let calendar = Calendar.current
        return completions.first {
            calendar.isDate($0.date, inSameDayAs: date)
        }?.numberOfTimesDone ?? 0
    }
    
    func numberOfTimesDoneToday() -> Int {
        numberOfTimesDone(on: Date())
    }
    
    func isCompleted(on date: Date) -> Bool {
        numberOfTimesDone(on: date) >= targetPerDay
    }
    
    func percentedCompleted(on date: Date) -> Double {
        Double(numberOfTimesDone(on: date)) / Double(targetPerDay)
    }
    
    var percentedCompletedToday: Double {
        percentedCompleted(on: Date())
    }
    
    
    

}
