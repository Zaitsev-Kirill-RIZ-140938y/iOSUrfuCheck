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
        let words = clearText.split(separator: " ")
        ScrollView(.vertical) {
            // Обернём всё в HStack и ForEach
            HStack {
                ForEach(words.indices, id: \.self) { idx in
                    Text(words[idx])
                        .foregroundColor(plagWords.contains(idx) ? .red : DS.Color.titleColor)
                        .font(DS.Font.fontText)
                        + Text(" ") // пробел после каждого слова
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
