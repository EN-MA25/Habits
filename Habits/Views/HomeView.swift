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
    @Query(sort: \Habit.createdAt) private var habits: [Habit]

    @State private var viewModel = HabitViewModel()
    @State private var isShowingAddHabit = false
    @State private var filter: HabitFilter = .all
    @State private var searchText: String = ""

    var filteredHabits: [Habit] {
        habits
            .filter { habit in
                switch filter {
                case .all:
                    return true
                case .completedToday:
                    return habit.isCompletedToday
                case .notCompletedToday:
                    return !habit.isCompletedToday
                }
            }
            .filter { habit in
                guard !searchText.isEmpty else { return true }

                let search = searchText
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                
                let nameMatch = habit.name.lowercased().contains(search)
                
                let noteMatch =
                    habit.note?
                    .lowercased()
                    .contains(search) ?? false

                return nameMatch || noteMatch
            }

    }

    var body: some View {
        NavigationSplitView {
            
            List {
                Picker("Filter", selection: $filter) {
                    Text("All").tag(HabitFilter.all)
                    Text("Done").tag(HabitFilter.completedToday)
                    Text("Not Done").tag(HabitFilter.notCompletedToday)
                }
                .pickerStyle(.segmented)
                if filteredHabits.isEmpty {
                    Text("No habits found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filteredHabits) { habit in
                        NavigationLink {
                            HabitDetailView(habit: habit)
                        } label: {
                            HabitListItemView(habit: habit) {
                                execute(habit: habit)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .sheet(isPresented: $isShowingAddHabit) {
                AddHabitView(existingHabits: habits)
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
        .searchable(text: $searchText, prompt: "Search")
        .environment(viewModel)
        .task {
            do {
                try await NotificationManager.shared.requestPermission()
            } catch {
                print("Could not request notification permission: \(error)")
            }
        }
    }

    private func execute(habit: Habit) {
        withAnimation {
            viewModel.incrementCompletionToday(for: habit)
        }
    }
    
    private func toggleDoneToday(for habit: Habit) {
        withAnimation {
            viewModel.toggleCompletion(for: habit)
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
