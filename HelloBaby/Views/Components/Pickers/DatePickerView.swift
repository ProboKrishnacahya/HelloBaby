//
//  DatePickerView.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 16/05/23.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        DatePicker("Select Date:", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.horizontal)
    }
}
