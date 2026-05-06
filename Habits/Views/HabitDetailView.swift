//
//  HabitDetailView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftUI

struct HabitDetailView: View {
    
    var habit: Habit
    
    var body: some View {
        Text(
            "\(habit.name) \(habit.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))"
        )
    }
}

#Preview {
    HabitDetailView(habit: Habit(name: "Kaffe"))
}
