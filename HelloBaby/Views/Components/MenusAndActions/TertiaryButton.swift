//
//  TertiaryButton.swift
//  HelloBaby
//
//  Created by Probo Krishnacahya on 16/05/23.
//

import SwiftUI

struct TertiaryButton: View {
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
            .foregroundColor(.indigo)
        }
    }
}
