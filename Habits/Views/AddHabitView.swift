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
    case count
}

struct AddHabitView: View {

    @Environment(\.modelContext) var context
    @Environment(HabitViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var note: String = ""
    @State private var habitsPerDayString: String = ""

    @FocusState private var focusedField: Field?

    let existingHabits: [Habit]

    @State private var showConfirmation = false
    
    @State private var reminderTime = Date()
    @State private var notificationsEnabled = false

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
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .count
                    }
                TextField("Habits per day (1 is default)", text: $habitsPerDayString)
                    .focused($focusedField, equals: .count)
                    .keyboardType(.numberPad)
                
                Section {

                    Toggle("Daily reminder", isOn: $notificationsEnabled)

                    if notificationsEnabled {

                        DatePicker(
                            "Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )

                    }

                }
                

            }
            .navigationTitle("New habit")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    showConfirmation = true
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
        
        viewModel.addHabit(name: name, targetPerDay: Int(habitsPerDayString) ?? 1, note: note, context: context, enabled: notificationsEnabled, reminderTime: reminderTime)
        
        dismiss()
    }

    var isDuplicate: Bool {
        existingHabits.contains {
            $0.name.lowercased().trimmingCharacters(in: .whitespaces)
                == name.lowercased().trimmingCharacters(in: .whitespaces)
        }
    }
}
