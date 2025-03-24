//
//  PrimaryButton.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () async -> Void

    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            Text(title)
                .font(DS.Font.fontTitleHead)
                .foregroundColor(DS.Color.titleColor)
                .frame(width: 342, height: 48)
                .background(DS.Color.positiveColor)
                .cornerRadius(40)
        }
    }
}
