//
//  HabitsView.swift
//  Habits
//
//  Created by Erik on 2026-05-04.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        Text("Habit at \(habit.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(habit.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Habit(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    HabitsView()
        .modelContainer(for: Habit.self, inMemory: true)
}
