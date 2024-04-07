//
//  Model.swift
//  FitFlex
//
//  Created by Navdeep Singh on 16/03/24.
//

import SwiftUI
import CoreData

struct Exercise: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    var bodyPart: BodyPart
}

struct BodyPart: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let exercises: [Exercise]
}

struct WeightEntry: Identifiable, Codable {
    let id = UUID()
    let exercise: Exercise
    let weight: Double
    let date: Date // Add date property
    var selectedSets: Int = 1
        // Other properties and methods as needed
        
        var dateString: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
}

struct GroupedWeightEntry: Identifiable {
    let id = UUID()
    let bodyPartName: String
    let entries: [WeightEntry]
}

