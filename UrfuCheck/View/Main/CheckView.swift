//
//  CheckView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import SwiftUI

struct CheckView: View {
    
    @StateObject private var vm = CheckViewModel()
    @State private var text = ""

    var body: some View {
        VStack(spacing: 16) {
            TextEditor(text: $text)
                .frame(height: 220)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary))

            Text("Осталось проверок: \(vm.remaining) / 5")
                .font(.footnote)

            Button("Проверить уникальность") {
                vm.run(text: text)
            }
            .disabled(
                text.count < 100 ||
                vm.remaining == 0 ||
                (vm.state == .running)
            )
            .buttonStyle(.borderedProminent)

            switch vm.state {
            case .running:
                ProgressView("Проверяем текст...")
            case .done(let unique):
                Text("Уникальность: \(unique, specifier: "%.2f")%")
            case .error(let msg):
                Text("Ошибка: \(msg)")
            default:
                EmptyView()
            }
        }
        .padding()
        .task {
            await vm.loadRemaining()
        }
    }
}

#Preview {
    CheckView()
}
