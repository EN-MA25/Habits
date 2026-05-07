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
//                Image(systemName: habit.isCompletedToday ? "checkmark.square.fill" : "square")
//                    .font(.title2)
                Image(systemName: "plus.circle.fill")
            
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(habit.name)
                
                if let note = habit.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("\(habit.numberOfTimesDoneToday()) / \(habit.targetPerDay) Streak: \(habit.currentStreak), Max Streak: \(habit.maxStreak)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HabitListItemView(habit: Habit(name: "Test", targetPerDay: 3), action: {})
}
