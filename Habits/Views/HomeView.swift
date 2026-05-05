//
//  HomeView.swift
//  Habits
//
//  Created by Erik on 2026-05-04.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    @State private var viewModel = HabitViewModel()
    @State private var isShowingAddHabit = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailView(habit: habit)
                    } label: {
                        HabitListItemView(habit: habit) {
                            toggleDoneToday(for: habit)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(isPresented: $isShowingAddHabit) {
                AddHabitView()
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        isShowingAddHabit = true
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .environment(viewModel)
    }

    private func toggleDoneToday(for habit: Habit) {
        withAnimation {
            viewModel.toggleCompletion(for: habit)
        }
    }
    
    private func addItem() {
        withAnimation {
            viewModel.addHabit(name: "Test", context: modelContext)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.deleteHabit(habits[index], context: modelContext)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Habit.self, inMemory: true)
}
