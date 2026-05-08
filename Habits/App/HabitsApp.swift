//
//  HabitsApp.swift
//  Habits
//
//  Created by Erik on 2026-05-04.
//

import SwiftData
import SwiftUI

@main
struct HabitsApp: App {
    
    @State private var showStartScreenView = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showStartScreenView {
                    StartScreenView()
                        .transition(.opacity)
                } else {
                    HomeView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: showStartScreenView)
            .task {
                try? await Task.sleep(for: .seconds(1.2))
                showStartScreenView = false
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

struct StartScreenView: View {
    var body: some View {
        ZStack {
            Color("StartScreenBackground")
                .ignoresSafeArea()
            Text("HABITS")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(Color("StartScreenText"))
        }
    }
}

#Preview {
    StartScreenView()
}
