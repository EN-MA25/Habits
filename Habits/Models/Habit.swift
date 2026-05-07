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

    init(name: String, note: String? = nil) {
        self.name = name
        self.note = note
        self.createdAt = Date()
        self.completions = []
    }
}

extension Habit {

    func hasCompletion(on date: Date) -> Bool {
        completions.contains {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    var isCompletedToday: Bool {
        completions.contains {
            Calendar.current.isDateInToday($0.date)
        }
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

}
