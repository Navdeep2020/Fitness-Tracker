//
//  GoalsView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 17/03/24.
//

import SwiftUI
import Charts

enum PRGoal: String, CaseIterable {
    case chest
    case back
    case shoulders
    case biceps
    case triceps
    case legs
    
    var exercises: [String] {
        switch self {
        case .chest:
            return ["Bench Press", "Flatbench DB Press", "Incline Bench Press"]
        case .back:
            return ["Latt-Pull down", "Pull-ups", "Barbell Rows"]
        case .shoulders:
            return ["Shoulder press", "Lateral Raises", "Front Raises"]
        case .biceps:
            return ["Bicep Curls", "Hammer Curls", "Preacher Curls"]
        case .triceps:
            return ["Tricep Dips", "Skull Crushers", "Tricep Pushdowns"]
        case .legs:
            return ["Squats", "Leg Press", "Leg extensions"]        }
    }
}

struct ExerciseEntry: Hashable {
    var bodyPart: String
    var exercise: String
    var prGoal: Double
}

struct GoalsView: View {
    // Constants
    let caloriesPerKg: Double = 7700 // Calories in 1 kg of body weight
    // let averageCaloriesBurnedPerDay: Double = 2000 // Average daily calories burned
    
    // Properties
    @State private var currentWeightInput: String = "80" // Current weight input
    @State private var goalWeightInput: String = "70" // Goal weight input
    @State private var selectedCaloriesPerDayIndex: String = "2000"
    
    // PR Goals
    @State private var exercise: String = ""
    @State private var prGoal: String = ""
    @State private var selectedPRGoal: PRGoal = .chest
    @State private var exerciseEntries: [ExerciseEntry] = []
    
    // ChartView
    @State private var chartView = false
    @State private var selectedEntry: ExerciseEntry? = nil
  
    
    // Calculated properties
    var currentWeight: Double {
        Double(currentWeightInput) ?? 0
    }
    
    var goalWeight: Double {
        Double(goalWeightInput) ?? 0
    }
    
    var weightDifference: Double {
        currentWeight - goalWeight
    }
    
    /// Works for simple
//    var daysToAchieveGoal: Int {
//        guard let calories = Double(selectedCaloriesPerDayIndex) else {
//            return 0 // or any other default value
//        }
//        
//        let totalCaloriesToBurn = weightDifference * caloriesPerKg
//        return Int(totalCaloriesToBurn / calories)
//    }

    var daysToAchieveGoal: Int {
        guard let calories = Double(selectedCaloriesPerDayIndex), calories != 0 else {
            return 0 // Return 0 if calories cannot be converted to a valid non-zero Double
        }
        
        let totalCaloriesToBurn = weightDifference * caloriesPerKg
        
        // Check for NaN or infinite results
        guard totalCaloriesToBurn.isFinite else {
            return 0 // Return 0 if the result is infinite or NaN
        }
        
        let days = totalCaloriesToBurn / calories
        
        // Check if days is finite and not NaN
        guard days.isFinite && !days.isNaN else {
            return 0 // Return 0 if the result is infinite or NaN after division
        }
        
        return Int(days)
    }

    
    let caloriesOptions: [Int] = Array(3..<31).map { $0 * 100 }
    @State private var sampleData: [Double] = []
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Picker("PR Goal", selection: $selectedPRGoal) {
                        ForEach(PRGoal.allCases, id: \.self) { goal in
                            Text(goal.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Picker("Exercise", selection: $exercise) {
                        ForEach(selectedPRGoal.exercises, id: \.self) { exercise in
                            Text(exercise)
                                .bold()
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    TextField("PR Goal (in kgs)", text: $prGoal)
                        .keyboardType(.decimalPad)
                        .padding()
                                        
                    Button(action: {
                        // Save exercise entry
                        let prGoalValue = Double(prGoal) ?? 0.0
                        let entry = ExerciseEntry(bodyPart: selectedPRGoal.rawValue, exercise: exercise, prGoal: prGoalValue)
                        exerciseEntries.append(entry)
                        // Perform any action with the entry here
                        print("Exercise Entry: \(entry)")
                        
                        // Clear fields
                        exercise = ""
                        prGoal = ""
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .background(Color.pink)
                            .mask(Circle())
                            .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0))
                            .shadow(color: Color.pink,radius: 10)
                    }
                    .padding()
                    
//                    ScrollView(.horizontal) {
//                        ScrollViewReader { proxy in
//                            HStack {
//                                ForEach(exerciseEntries, id: \.self) { entry in
//                                    ExerciseEntryView(entry: entry)
//                                        .id(entry) // Ensure unique IDs for each entry
//                                        .onLongPressGesture {
//                                            if let index = exerciseEntries.firstIndex(of: entry) {
//                                                exerciseEntries.remove(at: index)
//                                            }
//                                        }
//                                }
//                                .onChange(of: exerciseEntries) { _ in
//                                    withAnimation {
//                                        proxy.scrollTo(exerciseEntries.last, anchor: .trailing)
//                                    }
//                                }
//                            }
//                        }
//                    }
                    ScrollView(.horizontal) {
                        ScrollViewReader { proxy in
                            HStack {
                                ForEach(exerciseEntries, id: \.self) { entry in
                                    ZStack(alignment: .topTrailing) {
                                        ExerciseEntryView(entry: entry)
                                            .id(entry) // Ensure unique IDs for each entry
                                        
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .padding(8)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    deleteEntry(entry)
                                                }
                                                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 16))
                                    }
                                }
                                .onChange(of: exerciseEntries) { _ in
                                    withAnimation {
                                        proxy.scrollTo(exerciseEntries.last, anchor: .trailing)
                                    }
                                }
                            }
                        }
                    }

                }
                .padding()
                
                VStack {
                    Text("Enter Current Weight and Goal Weight")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        // TextField for current weight
                        TextField("Current Weight (kg)", text: $currentWeightInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: currentWeightInput) { _ in
                                updateSampleData()
                            }
                        
                        // TextField for goal weight
                        TextField("Goal Weight (kg)", text: $goalWeightInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: goalWeightInput) { _ in
                                updateSampleData()
                            }
                    }
                    
                    LineGraph(data: sampleData, title: "Weight Loss Progress")
                        .frame(height: 200)
                        .padding()
                    
                    Text("Estimated Days to Achieve Goal: \(daysToAchieveGoal)")
                        .font(.subheadline)
                    Text("If you burn \(Int(selectedCaloriesPerDayIndex)) calories per day")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    
                    Text("Select Calories which you can burn daily")
                        .font(.headline)
                    
                    TextField("Enter Calories to Burn", text: $selectedCaloriesPerDayIndex)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                    
                }
                .navigationBarTitle("Milestones", displayMode: .automatic)
                .onAppear {
                    updateSampleData()
                }
                .onTapGesture {
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        
    }
    
    func deleteEntry(_ entry: ExerciseEntry) {
        if let index = exerciseEntries.firstIndex(of: entry) {
            exerciseEntries.remove(at: index)
        }
    }
    
    // Function to update sample data
    private func updateSampleData() {
        // Generate sample data for demonstration purpose
        var data: [Double] = []
        guard let currentWeight = Double(currentWeightInput), daysToAchieveGoal > 0  else {
            sampleData = data // Return empty array if currentWeightInput is not a valid Double
            return
        }
        
        let daysToAchieveGoal = self.daysToAchieveGoal // Fetch daysToAchieveGoal
        
        for i in 0..<daysToAchieveGoal {
            let weight = currentWeight - (weightDifference / Double(daysToAchieveGoal) * Double(i))
            data.append(weight)
        }
        sampleData = data
    }
    
    struct LineGraph: View {
        let data: [Double] // Data points for the graph
        let title: String // Title for the graph
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Draw the background grid
                    ForEach(0..<5) { index in
                        let y = geometry.size.height / 4 * CGFloat(index)
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    
                    // Draw the data points and connect them with lines
                    Path { path in
                        for (index, value) in data.enumerated() {
                            let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
                            let y = geometry.size.height - CGFloat(value) * geometry.size.height / CGFloat(data.max() ?? 1)
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }

}

struct ExerciseEntryView: View {
    var entry: ExerciseEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Body Part: \(entry.bodyPart)")
                .font(.headline)
            Text("Exercise: \(entry.exercise)")
                .font(.subheadline)
            Text("PR Goal: \(Int(entry.prGoal)) kgs")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

#Preview {
    GoalsView()
}
