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

        GeometryReader { geometry in
            let size = min(
                geometry.size.width,
                geometry.size.height
            )
            ZStack {
                CircleDiagramView(progress: progress)
                    .opacity(isCurrentMonth ? 1 : 0)
                Text(dayNumber)
                    .font(.system(size: fontSize(for: size), weight: .semibold))
                    .foregroundStyle(isCurrentMonth ? .primary : .secondary)
            }
        }
        .aspectRatio(1, contentMode: .fit)
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

    private func fontSize(for size: CGFloat) -> CGFloat {
        size * 0.35
    }
}

#Preview {
    DayView(
        date: Date(),
        progress: 0.25,
        isCompleted: false,
        isCurrentMonth: true,
        isToday: true
    )
}
