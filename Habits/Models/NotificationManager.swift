//
//  NotificationManager.swift
//  Habits
//
//  Created by Erik on 2026-05-07.
//

import SwiftData
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()
    private init() {}

    func requestPermission() async throws {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])
    }

    func scheduleNextReminder(for habit: Habit) {
        cancelReminder(for: habit)

        guard habit.notificationsEnabled else { return }

        let calendar = Calendar.current
        let now = Date()

        var components = DateComponents()
        components.hour = habit.notificationHour
        components.minute = habit.notificationMinute

        var nextDate =
            calendar.nextDate(
                after: now,
                matching: components,
                matchingPolicy: .nextTime
            ) ?? now

        if habit.isCompleted(on: nextDate) {
            nextDate =
                calendar.date(byAdding: .day, value: 1, to: nextDate)
                ?? nextDate
        }

        let finalComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: nextDate
        )

        let content = UNMutableNotificationContent()
        content.title = "Habit reminder"
        content.body = "Time to complete: \(habit.name)"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: finalComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: notificationID(for: habit),
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for habit: Habit) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [notificationID(for: habit)]
            )
    }

    private func notificationID(for habit: Habit) -> String {
        "habit-reminder-\(habit.persistentModelID)"
    }

    func notificationPermissionGranted() async -> Bool {
        let settings = await UNUserNotificationCenter.current()
            .notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true

        case .notDetermined:
            do {
                return try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                return false
            }

        case .denied:
            return false

        @unknown default:
            return false
        }
    }

}
