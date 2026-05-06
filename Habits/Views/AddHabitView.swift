//
//  AddHabitView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftData
import SwiftUI

enum Field {
    case name
    case note
}

struct AddHabitView: View {

    @Environment(\.modelContext) var context
    @Environment(HabitViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var note: String = ""

    @FocusState private var focusedField: Field?

    let existingHabits: [Habit]

    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .note
                    }
                
                TextField("Note (Optional)", text: $note)
                    .focused($focusedField, equals: .note)
                    .submitLabel(name.isEmpty || isDuplicate ? .next : .done)
                    .onSubmit {
                        if name.isEmpty || isDuplicate {
                            focusedField = .name
                        } else {
                            showConfirmation = true
                        }
                    }

            }
            .navigationTitle("New habit")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    addHabit()
                }
                .disabled(name.isEmpty || isDuplicate)
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = .name
            }
        }
        .alert("Add Habit", isPresented: $showConfirmation) {
            Button("Yes") {
                addHabit()
            }
            Button("No", role: .cancel) { focusedField = .name}
        } message: {
            Text("Would you like to add \(name) as a new note")
        }
    }
    
    func addHabit() {
        viewModel.addHabit(name: name, note: note, context: context)
        dismiss()
    }

    var isDuplicate: Bool {
        existingHabits.contains {
            $0.name.lowercased().trimmingCharacters(in: .whitespaces)
                == name.lowercased().trimmingCharacters(in: .whitespaces)
        }
    }
}
