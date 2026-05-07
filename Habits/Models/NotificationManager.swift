//
//  NotificationManager.swift
//  Habits
//
//  Created by Erik on 2026-05-07.
//

import UserNotifications
import SwiftData

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func requestPermission() async throws {

        try await UNUserNotificationCenter.current()

            .requestAuthorization(options: [.alert, .badge, .sound])

    }

    func scheduleDailyReminder(for habit: Habit) {

        cancelReminder(for: habit)

        guard habit.notificationsEnabled else { return }

        let content = UNMutableNotificationContent()

        content.title = "Habit reminder"

        content.body = "Time to complete: \(habit.name)"

        content.sound = .default

        var dateComponents = DateComponents()

        dateComponents.hour = habit.notificationHour

        dateComponents.minute = habit.notificationMinute

        let trigger = UNCalendarNotificationTrigger(

            dateMatching: dateComponents,

            repeats: true

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

}
