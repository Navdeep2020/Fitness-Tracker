//
//  RootView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 07/04/24.
//

import SwiftUI

class WeightManager: ObservableObject {
    @Published var entries: [WeightEntry] = []
    
    // Load entries from UserDefaults on app launch
    init() {
        if let data = UserDefaults.standard.data(forKey: "WeightEntries"),
           let decodedEntries = try? JSONDecoder().decode([WeightEntry].self, from: data) {
            entries = decodedEntries
        }
    }
    
    // Save entries to UserDefaults whenever entries are updated
    func saveEntries() {
        if let encodedEntries = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encodedEntries, forKey: "WeightEntries")
        }
    }
    
    var groupedEntries: [GroupedWeightEntry] {
        let groupedDictionary = Dictionary(grouping: entries, by: { $0.exercise.bodyPart.name })
        return groupedDictionary.map { key, value in
            GroupedWeightEntry(bodyPartName: key, entries: value)
        }
    }
}

struct RootView: View {
    
    // checking user already exists
    @State private var showSignInView = false
    
    @StateObject var weightManager = WeightManager()
    @State private var entries: [WeightEntry] = []

    var body: some View {
        ZStack {
            NavigationStack {
               // SettingsView(showSignInView: $showSignInView)
                TabView {
                    HomeView(showSignInView: $showSignInView)
                        .tabItem {
                            Image(systemName: "house.circle.fill")
                            Text("Home")
                        }
                        .environmentObject(weightManager)
                    
                    WeightsView()
                        .tabItem {
                            Image(systemName: "dumbbell.fill")
                            Text("Log Weights")
                        }
                        .environmentObject(weightManager)
                    
                    GoalsView()
                        .tabItem {
                            Image(systemName: "flag.checkered.2.crossed")
                            Text("Milestones")
                        }
                        .environmentObject(weightManager)
                    
                    AccountView()
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                            
                        }
                    
                    DailyStepsView()
                        .tabItem {
                            Image(systemName: "figure.step.training")
                            Text("Steps")
                            
                        }
                    
                    CalendarView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Consistency")
                        }
                    
                }
                .onReceive(weightManager.$entries) { _ in
                    weightManager.saveEntries()
                }
                .environmentObject(weightManager)
            }
        }.onAppear {
            let authuser  = try? AuthenticationManager.shared.getUser()
            self.showSignInView = authuser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                AuthenticationView()
            }
        })
    }
}

#Preview {
    RootView()
}
