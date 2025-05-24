//
//  UrlListView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 23.05.2025.
//

import SwiftUI

struct UrlListView: View {
    let urls: [PlagiarismUrl]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(urls) { urlInfo in
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(urlInfo.url)
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .underline()
                    } icon: {
                        Image(systemName: "link")
                            .foregroundColor(DS.Color.positiveColor)
                    }
                    Text("Плагиат: \(Int(urlInfo.plagiat))%")
                        .font(.caption)
                        .foregroundColor(DS.Color.negativColor)
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
