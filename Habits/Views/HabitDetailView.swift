//
//  HabitDetailView.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import SwiftUI

struct HabitDetailView: View {

    let habit: Habit
    @State private var currentMonth: Date = Date()
    @Environment(HabitViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerView()
                monthView()
                weekView()
                calendarView()
            }
            .padding()
        }
    }
    
    // MARK: - Views
    
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(habit.name)
                .font(.title)
                .fontWeight(.bold)
            
            if let note = habit.note, !note.isEmpty {
                Text(note)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Current streak: \(habit.currentStreak)")
                Spacer()
                Text("Max streak: \(habit.maxStreak)")
            }
            .font(.subheadline)
        }
    }
    
    private func monthView() -> some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(monthTitle)
                .font(.headline)
            
            Spacer()
            
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(isCurrentMonth(date: Date()))
        }
        .padding()
    }
    
    private func weekView() -> some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func calendarView() -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7),
            spacing: 12
        ) {
            ForEach(daysInMonth(for: currentMonth), id: \.self) { date in
                DayView(
                    date: date,
                    isCompleted: habit.hasCompletion(on: date),
                    isCurrentMonth: isCurrentMonth(date: date),
                    isToday: calendar.isDateInToday(date)
                )
                .onTapGesture {
                    //MARK: - Test. In production it should not be used.
                    viewModel.toggleCompletion(for: habit, atDate: date)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: Calculeted Properties
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = Locale.current.calendar.firstWeekday
        return cal
    }
    
    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let firstDayIndex = calendar.firstWeekday - 1
        return Array(symbols[firstDayIndex...] + symbols[..<firstDayIndex])
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    //MARK: Functions
    private func isCurrentMonth(date: Date) -> Bool {
        calendar.isDate(
            date,
            equalTo: currentMonth,
            toGranularity: .month
        )
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        ) {
            currentMonth = newMonth
        }
    }

    private func daysInMonth(for date: Date) -> [Date] {

        guard
            let monthInterval = calendar.dateInterval(of: .month, for: date),
            let firstWeek = calendar.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.start
            ),
            let lastWeek = calendar.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.end - 1
            )
        else { return [] }

        var days: [Date] = []
        var current = firstWeek.start

        while current < lastWeek.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return days
    }

}
