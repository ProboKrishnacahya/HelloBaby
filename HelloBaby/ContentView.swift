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
    
    // State variables to store Information icon active state
    @State private var isSheetPresented = false
    
    var body: some View {
        // Wrapping the view in a NavigationStack for navigation purposes
        NavigationStack {
            // Creating a Form to display the calculation form page
            Form {
                // LMP Date section
                Section() {
                    // DatePicker to select the LMP date
                    VStack(alignment:.leading, spacing: 16) {
                        Text("Last Menstrual Period Date")
                            .font(.title2.bold())
                        Text("Select Date:")
                            .foregroundColor(.secondary)
                        DatePicker("", selection: $lmpDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                    
                    // Calculate button section
                    PrimaryButton(icon: "arrow.right", title: "Calculate", action: calculateEDD)
                }
                .listRowSeparator(.hidden)
                
                // EDD section
                Section() {
                    // DatePicker to display the calculated EDD date
                    HStack {
                        Image(systemName: "figure.2.and.child.holdinghands")
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text("Estimated Delivery Date")
                                .font(.title2.bold())
                            Text("\(eddDate.formatted(date: .long, time: .omitted))")
                                .foregroundColor(.secondary)
                        }
                    }
                    PrimaryButton(icon: "info.circle", title: "Information") {
                        isSheetPresented.toggle()
                    }
                    .sheet(isPresented: $isSheetPresented) {
                        SheetView()
                    }
                }
                .listRowSeparator(.hidden)
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

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 4) {
                Text("The Neagle Formula Method can be used to calculate gestational age based on the first day of the last 18 menstrual periods (LMP) to the date when the anamnesis was performed taking into account the gestational age lasting 280 days (40 weeks). Gestational age is determined in weeks. In addition, it can also estimate the estimated day of delivery / birth (EDD). However, this formula can only be used for women whose menstrual cycles are regular.\n\nMeanwhile, steps to calculate the Estimated Day of Birth (EDD), namely:")
                VStack(spacing: 4) {
                    Text("1. If the LMP is in January and mid-March (before the 25th) = +7 +9 +0\nExample: LMP 6 January 2013 = 6 / 1 / 2013 = +7 +9 +0 -> So the EDD = 13 / 10 / 2013 (13 Oct 2013)")
                        .padding(.leading, 16)
                    Text("2. If the LMP is later than mid-March (From the 25th and beyond) and so on until the end of December = +7 -3 +1\nExample: LMP 8 July 2013 = 8/7/2013 = +7 -3 +1 -> So EDD = 15/4/2014 (15 Apr 2014)")
                        .padding(.leading, 16)
                }
                Spacer()
            }
            .navigationBarItems(trailing: Button("Done", action: {
                presentationMode.wrappedValue.dismiss()
            }).foregroundColor(.indigo))
            .navigationTitle("Neagle Formula Method")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
