//
//  StepListView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 24/03/24.
//

import SwiftUI

struct StepListView: View {
    let steps: [Step]
    
    var body: some View {
        List(steps) { step in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(isUnder8000(step.count) ? .red: .green)
                    
                Text("\(step.count)")
                Spacer()
                Text(step.date.formatted(date: .abbreviated, time: .omitted))
            }
        }.listStyle(.plain)
    }
}

#Preview {
    StepListView(steps: [])
}
