//
//  DayView.swift
//  Habits
//
//  Created by Erik on 2026-05-07.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let progress: Double
    let isCompleted: Bool
    let isCurrentMonth: Bool
    let isToday: Bool

    var body: some View {
        ZStack {
            CircleDiagramView(progress: progress)
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
        let calendar = Calendar.current
        return String(calendar.component(.day, from: date))
    }
}

#Preview {
    DayView(date: Date(), progress: 0.25, isCompleted: false, isCurrentMonth: false, isToday: true)
}
