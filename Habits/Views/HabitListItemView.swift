//
//  HabitListItemView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftUI

struct HabitListItemView: View {
    
    var habit: Habit
    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: habit.isCompletedToday ? "checkmark.square.fill" : "square")
                    .font(.title2)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(habit.name)
                Text("Streak: \(habit.currentStreak), Max Streak: \(habit.maxStreak)")
            }
        }
    }
}

#Preview {
    HabitListItemView(habit: Habit(name: "Test"), action: {})
}
