//
//  HistoryViewRow.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 12.06.2025.
//

import SwiftUI

struct HistoryRow: View {
    let response: CheckResponse

    private var fraction: Double {
        max(0, min(1, (response.jsonResult?.unique ?? 0) / 100))
    }
    private var percentUnique: Int { Int(fraction * 100) }
    private var snippet: String {
        String(response.clearText.prefix(50))
    }
    private var dateText: String {
        response.jsonResult?.dateCheck ?? ""
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(DS.Color.negativColor, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(DS.Color.positiveColor, lineWidth: 8)
                    .rotationEffect(.degrees(-90))
                Text("\(percentUnique)%")
                    .font(DS.Font.fontText)
                    .foregroundStyle(DS.Color.titleColor)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .trailing, spacing: 4) {
                Text(snippet + (response.clearText.count > 50 ? "…" : ""))
                    .font(DS.Font.fontText)
                    .foregroundStyle(DS.Color.titleColor)
                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(DS.Color.textColor)
            }

            Spacer()
        }
        .padding()
        .background(DS.Color.navColor)
        .cornerRadius(8)
    }
}
