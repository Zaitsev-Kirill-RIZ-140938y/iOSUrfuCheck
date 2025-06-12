//
//  UrlListView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 23.05.2025.
//

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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(urls) { urlInfo in
                    VStack(alignment: .leading, spacing: 8) {
                        Link(destination: URL(string: urlInfo.url)!) {
                            HStack(spacing: 6) {
                                Image(systemName: "link")
                                    .foregroundColor(DS.Color.positiveColor)
                                Text(urlInfo.url)
                                    .font(.footnote)
                                    .foregroundStyle(DS.Color.titleColor)
                                    .underline()
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                        }

                        Text("Плагиат: \(Int(urlInfo.plagiat))%")
                            .font(.caption)
                            .foregroundStyle(DS.Color.negativColor)
                    }
                    .background(DS.Color.navColor)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    UrlListView(urls: [
        PlagiarismUrl(url: "https://example.com/long/url/example", plagiat: 75, words: nil),
        PlagiarismUrl(url: "https://habr.com/ru/articles/12345/", plagiat: 42, words: nil)
    ])
}
