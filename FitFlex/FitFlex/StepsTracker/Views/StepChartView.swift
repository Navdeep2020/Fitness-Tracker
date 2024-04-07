//
//  StepChartView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 24/03/24.
//

import SwiftUI
import Charts

struct StepChartView: View {
    
    let steps: [Step]
    
    var body: some View {
        Chart {
            ForEach(steps) { step in
                BarMark(x: .value("Date", step.date), y: .value("Count", step.count))
                    .foregroundStyle(isUnder8000(step.count) ? .red: .green)
            }
        }
    }
}

//#Preview {
//    StepChartView()
//}
