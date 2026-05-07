//
//  DayView.swift
//  Habits
//
//  Created by Erik on 2026-05-07.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let isCompleted: Bool
    let isCurrentMonth: Bool
    let isToday: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? Color.green.opacity(0.3) : Color.clear)
            Text(dayNumber)
                .font(.subheadline)
                .foregroundStyle(isCurrentMonth ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(4)
        .background(
            ZStack {
                if isToday {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                }
            }
        )
    }

    private var dayNumber: String {
        var calendar = Calendar.current
        calendar.firstWeekday = Locale.current.calendar.firstWeekday
        return String(calendar.component(.day, from: date))
    }
}

#Preview {
    DayView(date: Date(), isCompleted: true, isCurrentMonth: false, isToday: true)
}
