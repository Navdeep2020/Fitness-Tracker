//
//  WeightsView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 16/03/24.
//

import SwiftUI
import CoreData

struct WeightsView: View {
    
    @EnvironmentObject var weightManager: WeightManager
    
    @State var selectedBodyPart: BodyPart?
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedWeight: Int = 5
    @State private var weightText: String = ""
    @State private var entries: [WeightEntry] = []

    @State private var showTickIcon = false
    
    let bodyParts = [
        
        BodyPart(name: "Chest", exercises: [
            Exercise(name: "Incline Bench Press", bodyPart: BodyPart(name: "Chest", exercises: [])),
            Exercise(name: "Pec-Dec Fly", bodyPart: BodyPart(name: "Chest", exercises: [])),
            Exercise(name: "Incline Hammer", bodyPart: BodyPart(name: "Chest", exercises: [])),
            Exercise(name: "Dumbbell over head", bodyPart: BodyPart(name: "Chest", exercises: [])),
            Exercise(name: "Decline Bench Press", bodyPart: BodyPart(name: "Chest", exercises: [])),
            Exercise(name: "Dumbbell Fly", bodyPart: BodyPart(name: "Chest", exercises: []))
        ]),
        
        BodyPart(name: "Back", exercises: [
            Exercise(name: "Lat Pulldowns", bodyPart: BodyPart(name: "Back", exercises: [])),
            Exercise(name: "Seated Cable", bodyPart: BodyPart(name: "Back", exercises: [])),
            Exercise(name: "T-Bar Row", bodyPart: BodyPart(name: "Back", exercises: [])),
            Exercise(name: "Rod for Lats", bodyPart: BodyPart(name: "Back", exercises: [])),
            Exercise(name: "One arm shoulder", bodyPart: BodyPart(name: "Back", exercises: [])),
            Exercise(name: "Lower Back", bodyPart: BodyPart(name: "Back", exercises: [])),
            
        ]),
        
        BodyPart(name: "Biceps", exercises: [
            Exercise(name: "Preacher curl", bodyPart: BodyPart(name: "Biceps", exercises: [])),
            Exercise(name: "Standing Hammer", bodyPart: BodyPart(name: "Biceps", exercises: [])),
            Exercise(name: "Rod-pullup(Fore-hand)", bodyPart: BodyPart(name: "Biceps", exercises: [])),
            Exercise(name: "Standing Dumbbell curl", bodyPart: BodyPart(name: "Biceps", exercises: [])),
            Exercise(name: "Long Rod Curl", bodyPart: BodyPart(name: "Biceps", exercises: [])),
            
        ]),
        
        BodyPart(name: "Triceps", exercises: [
            Exercise(name: "Incline bench extension", bodyPart: BodyPart(name: "Triceps", exercises: [])),
            Exercise(name: "Rod-push down", bodyPart: BodyPart(name: "Triceps", exercises: [])),
            Exercise(name: "Rope-push down", bodyPart: BodyPart(name: "Triceps", exercises: [])),
            Exercise(name: "Over-head extension", bodyPart: BodyPart(name: "Triceps", exercises: [])),
            Exercise(name: "Tricep dips(body weight)", bodyPart: BodyPart(name: "Triceps", exercises: [])),
            
        ]),
        
        BodyPart(name: "Shoulders", exercises: [
            Exercise(name: "Dumbell-Fly", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            Exercise(name: "Dumbell-FrontRaise", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            Exercise(name: "Smith-machine press", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            Exercise(name: "Shrugs", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            Exercise(name: "Rope pullover head", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            Exercise(name: "Rear delts", bodyPart: BodyPart(name: "Shoulders", exercises: [])),
            
        ]),
        
        BodyPart(name: "Legs", exercises: [
            Exercise(name: "Squats", bodyPart: BodyPart(name: "Legs", exercises: [])),
            Exercise(name: "Lunges", bodyPart: BodyPart(name: "Legs", exercises: [])),
            Exercise(name: "Leg Press", bodyPart: BodyPart(name: "Legs", exercises: [])),
            Exercise(name: "Leg Extensions", bodyPart: BodyPart(name: "Legs", exercises: [])),
            Exercise(name: "Sumo Squats", bodyPart: BodyPart(name: "Legs", exercises: [])),
            Exercise(name: "Calf Raises", bodyPart: BodyPart(name: "Legs", exercises: [])),
            
        ]),
        // Add more body parts here
    ]
    
    var body: some View {
        VStack {
           
            Spacer()
            Text("Log Your Weights")
                .font(.title)
                .fontWeight(.bold)
            
            VStack {
                GeometryReader { geometry in
                    let buttonWidth = (geometry.size.width - 110) / 3 // Assuming 16 is the padding
                    ScrollView {
                        HStack {
                            ForEach(bodyParts.prefix(3)) { part in
                                Button(action: {
                                    selectedBodyPart = part
                                    selectedExercise = nil
                                }) {
                                    Text(part.name)
                                        .fontWeight(.semibold)
                                        .frame(width: buttonWidth)
                                        .padding()
                                        .background(selectedBodyPart == part ? Color.green.opacity(0.7) : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        HStack {
                            ForEach(bodyParts.suffix(from: 3)) { part in
                                Button(action: {
                                    selectedBodyPart = part
                                    selectedExercise = nil
                                }) {
                                    Text(part.name)
                                        .frame(width: buttonWidth)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .background(selectedBodyPart == part ? Color.green.opacity(0.7) : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            
            if let selectedPart = selectedBodyPart {
                List {
                    ForEach(selectedPart.exercises) { exercise in
                        Button(action: {
                            selectedExercise = exercise // Set selected exercise
                        }) {
                            Text(exercise.name)
                                .bold()
                                .foregroundColor(selectedExercise == exercise ? Color.green.opacity(0.9) : Color.black)
                        }
                    }
                }
                .listStyle(.plain)
                .padding()
            }
            
            if let selectedExercise = selectedExercise {
                Picker("Select Weight", selection: $selectedWeight) {
                    ForEach(1...(100 / 5), id: \.self) { index in
                        let weight = index * 5
                        Text("\(weight) kg").tag(weight)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
            }
            
            Button {
                logWeight()
                showTickIcon = true // Show tick icon after clicking
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Hide tick icon after 1 second
                    showTickIcon = false
                }
            } label: {
                Text("Log Weight")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .mask(Rectangle())
                    .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0))
                    .shadow(color: Color.blue,radius: 10)
                    .cornerRadius(8)
            }

            if showTickIcon {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .padding(.top, 20)
            }
            
//            Spacer()
//            
//            VStack {
//                // Your existing code
//                
//                if !entries.isEmpty {
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(entries) { entry in
//                                Text("\(entry.exercise.name), Weight Lifted: \(Int(entry.weight)) kg")
//                            }
//                        }
//                        .padding()
//                    }
//                } else {
//                    Text("No entries yet")
//                        .padding()
//                }
//            }
//            .padding()
//            .animation(.easeInOut)
        }
        .padding()
        .animation(.easeInOut)
    }
    
    func logWeight() {
        
            guard let exercise = selectedExercise else {
                print("Selected exercise is nil, returning from logWeight")
                return
            }
            guard selectedWeight > 0 else {
                print("Selected weight is not greater than 0, returning from logWeight")
                return
            }

            
        let entry = WeightEntry(exercise: exercise, weight: Double(selectedWeight), date: Date())
            weightManager.entries.append(entry)
            entries.append(entry)
            weightText = ""
        }
}

#Preview {
    WeightsView()
}
