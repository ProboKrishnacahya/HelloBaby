//
//  ContentView.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var lmpDate = Date()
    @State private var eddDate = Date()
    @State private var isCalculationPerformed = false
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 16) {
                        Text("Last Menstrual Period")
                            .font(.title2.bold())
                        Text("Select Date:")
                        DatePicker("Select Date:", selection: $lmpDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding(.horizontal)
                        PrimaryButton(icon: "arrow.right", title: "Calculate", action: calculateEDD)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    if isCalculationPerformed {
                        VStack(alignment: .center, spacing: 16) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar.circle")
                                    .font(Font.system(size: 56))
                                Text("Estimated Date of Delivery")
                                    .font(.title2.bold())
                            }
                            VStack {
                                Text("\(eddDate.formatted(date: .long, time: .omitted))")
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(lineWidth: 2)
                                    )
                                    .bold()
                            }
                            VStack(spacing: 16) {
                                Text("Your baby is predicted to be born on\n**\(eddDate.formatted(date: .long, time: .omitted))**.")
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                Divider()
                                Button {
                                    isSheetPresented.toggle()
                                } label: {
                                    Label("Learn More", systemImage: "info.circle")
                                }
                                .foregroundColor(.indigo)
                                .sheet(isPresented: $isSheetPresented) {
                                    SheetView()
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                }
                .navigationBarTitle("Calculation")
                .padding()
            }
            .onAppear {
                isCalculationPerformed = false
            }
        }
    }
    
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
        
        isCalculationPerformed = true
    }
    
    struct SheetView: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Formula")
                            .font(.title3.bold())
                        Text("The Neagle Formula Method can be used to calculate gestational age based on normal gestational age, namely 280 days (40 weeks or 9 months 7 days) calculated from the first day of the LMP (Last Menstrual Period) Date and not more than 300 days (43 weeks). Gestational age is determined in weeks. In addition, it can also predict the EDD (Estimated Date of Delivery). However, this formula can only be used for women whose menstrual cycles are regular.")
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calculation Steps")
                            .font(.title3.bold())
                        Text("Based on LMP Date")
                            .fontWeight(.semibold)
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("1. January until mid-March (Before the 25th):")
                                Text("Day + 7 / Month + 9 / Year + 0")
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(lineWidth: 2)
                                    )
                                    .bold()
                                Text("Example: LMP on February 2, 2023\n2 / 2 / 2023 + 7 / 9 / 0 = 9 / 11 / 2023\nSo, the EDD is **November 9, 2023**.")
                                    .foregroundColor(.secondary)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("2. From the 25th March until late December:")
                                Text("Day + 7 / Month - 3 / Year + 1")
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(lineWidth: 2)
                                    )
                                    .bold()
                                Text("Example: LMP on June 11, 2023\n11 / 6 / 2023 + 7 / (-3) / 1 = 18 / 3 / 2024\nSo, the EDD is **March 18, 2024**.")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.leading, 16)
                    }
                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                    .foregroundColor(.indigo))
                .navigationTitle("Neagle Formula Method")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
