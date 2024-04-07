//
//  CalenderView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 30/03/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var weightManager: WeightManager
    
    // Define the start date and number of months to display in the calendar
    let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())! // Start date 3 months ago
    let numberOfMonths = 6 // Set the number of months to display
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<numberOfMonths, id: \.self) { monthIndex in
                    let monthStartDate = Calendar.current.date(byAdding: .month, value: monthIndex, to: self.startDate)!
                    Section(header: Text("\(monthStartDate.monthName) \(monthStartDate.year)").font(.headline)) {
                        self.daysForMonth(monthStartDate)
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 5))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // Generate days for a given month
    // Generate days for a given month
    func daysForMonth(_ monthStartDate: Date) -> some View {
        let monthRange = Calendar.current.range(of: .day, in: .month, for: monthStartDate)!
        let firstWeekdayOfMonth = Calendar.current.component(.weekday, from: monthStartDate)
        
        var dayIndex = 0
        var days: [[Int?]] = [[]]
        
        // Initialize the days array with empty arrays for each week
        for _ in 0..<6 {
            days.append([])
        }
        
        // Fill in the days array with day numbers for the month
        for dayOfMonth in 1...monthRange.count {
            let weekdayIndex = (firstWeekdayOfMonth + dayIndex - 1) % 7
            days[dayIndex / 7].append(dayOfMonth)
            dayIndex += 1
        }
        
        // Pad the last week if necessary to ensure consistent layout
        if let lastWeek = days.last, lastWeek.count < 7 {
            days[5] += Array(repeating: nil, count: 7 - lastWeek.count)
        }
        
        return VStack(alignment: .leading, spacing: 5) {
            ForEach(0..<6, id: \.self) { weekIndex in
                HStack(alignment: .center, spacing: 2) {
                    ForEach(days[weekIndex], id: \.self) { dayOfMonth in
                        if let dayOfMonth = dayOfMonth {
                            let date = Calendar.current.date(byAdding: .day, value: dayOfMonth - 1, to: monthStartDate)!
                            DayView(date: date)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }


}

struct DayView: View {
    let date: Date
    @EnvironmentObject var weightManager: WeightManager
    
    var body: some View {
        let isWeightLogged = weightManager.entries.contains { entry in
            let entryDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: entry.date)
            let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return entryDateComponents.day == currentDateComponents.day && entryDateComponents.month == currentDateComponents.month
        }
        
        let isToday = Calendar.current.isDateInToday(date)
        let backgroundColor = isToday ? Color.blue : (isWeightLogged ? Color.green : Color.gray.opacity(0.2))
        
        Text(String(Calendar.current.component(.day, from: date)))
            .frame(width: 20, height: 20)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(backgroundColor)
            )
            .lineLimit(1) // Ensure only one line for text
            .minimumScaleFactor(0.5) // Adjust minimum scale factor if needed
    }
}




extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var monthName: String {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}


#Preview {
    CalendarView()
}
