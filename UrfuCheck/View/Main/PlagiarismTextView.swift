//
//  PlagiarismTextView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 23.05.2025.
//

import SwiftUI

struct PlagiarismTextView: View {
    let clearText: String
    let plagWords: [Int]

    var body: some View {
        ScrollView(.vertical) {
            Text(makeAttributed())
                .font(DS.Font.fontText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }

    private func makeAttributed() -> AttributedString {
        var attr = AttributedString("")
        let words = clearText.split(separator: " ", omittingEmptySubsequences: false)

        for (idx, w) in words.enumerated() {
            var piece = AttributedString(String(w))
            if plagWords.contains(idx) {
                piece.foregroundColor = .red
                piece.font            = DS.Font.fontText
            } else {
                piece.foregroundColor = DS.Color.titleColor
                piece.font            = DS.Font.fontText
            }
            attr += piece
            if idx != words.indices.last { attr += AttributedString(" ") }
        }
        return attr
    }
}

#Preview {
    PlagiarismTextView(
        clearText: "Это пример текста для проверки на плагиат выделением красным.",
        plagWords: [3, 5, 7]
    )
}
