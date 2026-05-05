//
//  HabitListItemView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftUI

struct HabitListItemView: View {
    
    var habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                Text(
                    habit.timestamp,
                    format: Date.FormatStyle(
                        date: .numeric,
                        time: .standard
                    )
                )
            }
        }
    }
}

#Preview {
    HabitListItemView(habit: Habit(name: "Test", timestamp: Date()))
}
