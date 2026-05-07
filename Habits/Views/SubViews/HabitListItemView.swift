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
            CircleDiagramView(progress: habit.percentedCompletedToday)
                .frame(width: 40, height: 40)
                .onTapGesture(perform: action)

            VStack(alignment: .leading) {
                Text(habit.name)
                
                if let note = habit.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("\(habit.numberOfTimesDoneToday())/\(habit.targetPerDay) Streak: \(habit.currentStreak), Max Streak: \(habit.maxStreak)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        
    }
}

#Preview {
    HabitListItemView(habit: Habit(name: "Test", targetPerDay: 3), action: {})
}
