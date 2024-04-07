//
//
//  HomeView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 16/03/24.
//

import SwiftUI
import CoreData

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

struct HomeView: View {
    
    @EnvironmentObject var weightManager: WeightManager
    @State private var sectionToDelete: WeightEntry? = nil
    @State private var sectionVisibility: [String: Bool] = [:] // Dictionary to track section visibility
    @Binding var showSignInView: Bool
    
    var body: some View {

        NavigationView {
                List {
                    // Get unique body part names
                    let uniqueBodyParts = weightManager.entries.map { $0.exercise.bodyPart.name }.uniqued()
                    
                    let groupedEntries = Dictionary(grouping: weightManager.entries) { entry in
                        return entry.dateString // Group by date string
                    }
                    
                    // Iterate over unique body parts
                    ForEach(groupedEntries.keys.sorted(), id: \.self) { date  in
                        let entriesForDate = groupedEntries[date]!
                        Section(header: HStack {
                            Text(date)
                            Spacer()
                            Button(action: {
                                // Toggle section visibility
                                self.sectionVisibility[date, default: true].toggle()
                            }) {
                                Image(systemName: self.sectionVisibility[date, default: true] ? "chevron.down" : "chevron.up")
                                    .foregroundColor(.blue)
                            }
                        }) {
                            
                            if self.sectionVisibility[date, default: true] {
                                // Iterate over entries for the current body part
                                ForEach(entriesForDate, id: \.id) { entry in
                                    HStack {
                                        Text(entry.exercise.name)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(Int(entry.weight)) kg")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .gesture(LongPressGesture(minimumDuration: 0.3)
                                        .onEnded { _ in
                                            sectionToDelete = entry
                                        })
                                }
                            }
                        }
                    }
                }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Home", displayMode: .automatic)
            .navigationBarItems(trailing:
                                    Button(action: {
                // Action
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            )
            //  .navigationBarTitle("Home")
            .alert(item: $sectionToDelete) { section in
                Alert(title: Text("Delete Section"),
                      message: Text("Are you sure you want to delete this section?"),
                      primaryButton: .destructive(Text("Delete")) {
                    deleteSection(section)
                },
                      secondaryButton: .cancel()
                )
            }
        }
    }
    
    func deleteSection(_ section: WeightEntry) {
        weightManager.entries.removeAll(where: { $0.id == section.id })
        weightManager.saveEntries()
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Function to get the dateString for a given body part name
        private func dateString(for bodyPartName: String) -> String? {
            // Filter entries for the given body part
            let entriesForBodyPart = weightManager.entries.filter { $0.exercise.bodyPart.name == bodyPartName }
            
            // If there are entries, return the dateString of the first entry
            if let firstEntry = entriesForBodyPart.first {
                return firstEntry.dateString
            } else {
                return nil
            }
        }
}

//#Preview {
//    HomeView()
//}
