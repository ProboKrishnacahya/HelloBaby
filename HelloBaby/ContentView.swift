//
//  ContentView.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    // State variables to store the selected LMP and EDD dates
    @State private var lmpDate = Date()
    @State private var eddDate = Date()
    
    var body: some View {
        // Wrapping the view in a NavigationStack for navigation purposes
        NavigationStack {
            // Creating a Form to display the calculation form page
            Form {
                // LMP Date section
                Section() {
                    // DatePicker to select the LMP date
                    VStack(alignment:.leading) {
                        Text("LMP Date")
                            .font(.title2.bold())
                        DatePicker("", selection: $lmpDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                }
                
                // EDD Date section
                Section() {
                    // DatePicker to display the calculated EDD date
                    HStack {
                        Image(systemName: "figure.2.and.child.holdinghands")
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text("EDD Date")
                                .font(.title2.bold())
                            Text("\(eddDate.formatted(date: .long, time: .omitted))")
                        }
                    }
                }
                
                // Calculate button section
                Section {
                    VStack {
                        PrimaryButton(icon: "arrow.right", title: "Calculate", action: calculateEDD)
                        PrimaryButton(icon: "info.circle", title: "Information", action: calculateEDD)
                    }
                }
            }
            .navigationBarTitle("EDD Calculation")
        }
    }
    
    // Function to calculate the EDD date based on the selected LMP date
    func calculateEDD() {
        let calendar = Calendar.current
        let lmpComponents = calendar.dateComponents([.day, .month, .year], from: lmpDate)
        
        let day = lmpComponents.day ?? 0
        let month = lmpComponents.month ?? 0
        let year = lmpComponents.year ?? 0
        
        var eddComponents = DateComponents()
        if month <= 3 || (month == 3 && day < 25) {
            eddComponents.day = day + 7
            eddComponents.month = month + 9
            eddComponents.year = year
        } else {
            eddComponents.day = day + 7
            eddComponents.month = month - 3
            eddComponents.year = year + 1
        }
        
        eddDate = calendar.date(from: eddComponents) ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

