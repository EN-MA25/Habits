//
//  AddHabitView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftData
import SwiftUI

struct AddHabitView: View {

    @Environment(\.modelContext) var context
    @Environment(HabitViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var note: String = ""


    let existingHabits: [Habit]

    @FocusState private var showKeyboard: Bool

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .focused($showKeyboard)
                TextField("Note (Optional)", text: $note)

            }
            .navigationTitle("New habit")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {

                    viewModel.addHabit(name: name, note: note, context: context)
                    dismiss()
                }
                .disabled(name.isEmpty || isDuplicate)
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showKeyboard = true
            }
        }
    }

    var isDuplicate: Bool {
        existingHabits.contains {
            $0.name.lowercased().trimmingCharacters(in: .whitespaces)
                == name.lowercased().trimmingCharacters(in: .whitespaces)
        }
    }
}
