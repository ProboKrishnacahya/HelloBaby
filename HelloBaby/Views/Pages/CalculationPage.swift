//
//  CalculationPage.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 15/05/23.
//

import SwiftUI
extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}

struct CalculationPage: View {
    @State private var lmpDate = Date()
    @State private var eddDate = Date()
    @State private var isCalculationPerformed = false
    @State private var isSheetPresented = false
    
    private var dayComponent: String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: lmpDate)
        return String(day)
    }
    
    private var monthComponent: String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: lmpDate)
        return String(month)
    }
    
    private var yearComponent: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: lmpDate)
        return String(year)
    }
    
    func calculateEDD() {
        let calendar = Calendar.current
        let lmpComponents = calendar.dateComponents([.day, .month, .year], from: lmpDate)
        
        guard let day = lmpComponents.day,
              let month = lmpComponents.month,
              let year = lmpComponents.year else {
            return
        }
        
        var eddComponents = DateComponents()
        if month >= 1 && month <= 3 {
            // January to March
            if month == 3 && day >= 25 {
                // After March 24
                eddComponents.day = day + 7
                eddComponents.month = month - 3
                eddComponents.year = year + 1
            } else {
                // January or February, or March 1-24
                eddComponents.day = day + 7
                eddComponents.month = month + 9
                eddComponents.year = year
            }
        } else {
            // April to December
            eddComponents.day = day + 7
            eddComponents.month = month - 3
            eddComponents.year = year + 1
        }
        
        guard let calculatedEDDDate = calendar.date(from: eddComponents) else {
            return
        }
        
        eddDate = calculatedEDDDate
        isCalculationPerformed = true
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 16) {
                        Text("Last Menstrual Period")
                            .font(.title2.bold())
                        Text("Select Date:")
                        DatePickerView(selectedDate: $lmpDate)
                        PrimaryButton(icon: "arrow.right", title: "Calculate", action: calculateEDD)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    if isCalculationPerformed {
                        VStack(alignment: .center, spacing: 16) {
//                            VStack(spacing: 4) {
                                Image(systemName: "calendar.circle")
                                    .font(Font.system(size: 56))
//                                Text("Estimated Date of Delivery")
//                                    .font(.title2.bold())
//                            }
                            VStack(spacing: 16) {
//                                VStack(spacing: 8) {
//                                    if(monthComponent <= "3" || (monthComponent == "3" && dayComponent < "25")) {
//                                        VStack(spacing: 8) {
//                                            Text("Day + 7 / Month + 9 / Year + 0")
//                                            Text("\(dayComponent) + 7 / \(monthComponent) + 9 / \(yearComponent) + 0")
//                                        }
//                                    } else {
//                                        VStack(spacing: 8) {
//                                            Text("Day + 7 / Month - 3 / Year + 1")
//                                            Text("\(dayComponent) + 7 / \(monthComponent) - 3 / \(yearComponent) + 1")
//                                        }
//                                    }
//                                    Text("\(eddDate, formatter: DateFormatter.shortDateFormatter)")
//                                        .padding(8)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 4)
//                                                .stroke(lineWidth: 2)
//                                        )
//                                        .bold()
//                                }
                                Text("Your baby is predicted to be born on")
                                Text("\(eddDate.formatted(date: .long, time: .omitted))")
                                    .font(.title2.bold())
                                Divider()
                                TertiaryButton(icon: "info.circle", title: "Learn More") {
                                    isSheetPresented.toggle()
                                }
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

struct CalculationPage_Previews: PreviewProvider {
    static var previews: some View {
        CalculationPage()
    }
}
