//
//  HistoryView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 12.06.2025.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var vm = HistoryViewModel()
    @State private var selected: CheckResponse?

    var body: some View {
        VStack {
            // Заголовок
            VStack(spacing: 30) {
                Text("История проверок")
                    .font(DS.Font.fontTitleHead)
                    .foregroundStyle(DS.Color.titleColor)
            }
            .padding(.top, 20)

            // Лоадер или список
            if vm.isLoading {
                ProgressView("Загрузка истории...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 20)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(vm.items) { item in
                            Button {
                                selected = item
                            } label: {
                                HistoryRow(response: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor.ignoresSafeArea())
        .task {
            await vm.loadHistory()
        }
        .sheet(item: $selected) { item in
            ResultCheckView(response: item)
        }
    }
}

#Preview {
    HistoryView()
}
