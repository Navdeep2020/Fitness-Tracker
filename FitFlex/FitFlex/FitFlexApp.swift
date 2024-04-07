//
//  FitFlexApp.swift
//  FitFlex
//
//  Created by Navdeep Singh on 10/03/24.
//

import SwiftUI
import Firebase

//class WeightManager: ObservableObject {
//    @Published var entries: [WeightEntry] = []
//    
//    // Load entries from UserDefaults on app launch
//    init() {
//        if let data = UserDefaults.standard.data(forKey: "WeightEntries"),
//           let decodedEntries = try? JSONDecoder().decode([WeightEntry].self, from: data) {
//            entries = decodedEntries
//        }
//    }
//    
//    // Save entries to UserDefaults whenever entries are updated
//    func saveEntries() {
//        if let encodedEntries = try? JSONEncoder().encode(entries) {
//            UserDefaults.standard.set(encodedEntries, forKey: "WeightEntries")
//        }
//    }
//    
//    var groupedEntries: [GroupedWeightEntry] {
//        let groupedDictionary = Dictionary(grouping: entries, by: { $0.exercise.bodyPart.name })
//        return groupedDictionary.map { key, value in
//            GroupedWeightEntry(bodyPartName: key, entries: value)
//        }
//    }
//}

@main
struct FitFlexApp: App {
    
    // Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
            
    @StateObject var weightManager = WeightManager() // Create an instance of WeightManager
    @AppStorage("status") var logged = false
    @State private var entries: [WeightEntry] = []
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                 RootView()
            }

//            if logged {
//                TabView {
//                    HomeView()
//                        .tabItem {
//                            Image(systemName: "house.circle.fill")
//                            Text("Home")
//                        }
//                        .environmentObject(weightManager)
//                    
//                    WeightsView()
//                        .tabItem {
//                            Image(systemName: "dumbbell.fill")
//                            Text("Log Weights")
//                        }
//                        .environmentObject(weightManager)
//                    
//                    GoalsView()
//                        .tabItem {
//                            Image(systemName: "flag.checkered.2.crossed")
//                            Text("Milestones")
//                        }
//                        .environmentObject(weightManager)
//                    
//                    AccountView()
//                        .tabItem {
//                            Image(systemName: "person.circle.fill")
//                            Text("Profile")
//                            
//                        }
//                    
//                    DailyStepsView()
//                        .tabItem {
//                            Image(systemName: "figure.step.training")
//                            Text("Steps")
//                            
//                        }
//                    
//                    CalendarView()
//                        .tabItem {
//                            Image(systemName: "calendar")
//                            Text("Consistency")
//                        }
//                    
//                }
//                .onReceive(weightManager.$entries) { _ in
//                     weightManager.saveEntries()
//                 }
//                .environmentObject(weightManager)
//            } else {
//                ContentView(email: "", password: "")
//            }
            
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
