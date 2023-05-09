//
//  Button.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 05/05/23.
//

import SwiftUI

struct PrimaryButton: View {
    var icon: String
    var title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.indigo)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
