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
        VStack {
            VStack(spacing: 30) {
                Text("Проверка на плагиат")
                    .font(DS.Font.fontTitleHead)
                    .foregroundStyle(DS.Color.titleColor)
                
                ZStack(alignment: .topLeading) {
                    // Placeholder
                    if text.isEmpty {
                        Text("Введите текст для проверки")
                            .foregroundStyle(DS.Color.textColor)
                            .font(DS.Font.fontText)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(DS.Color.titleColor)
                        .font(DS.Font.fontText)
                    
                    Spacer()
                    
                    HStack {
                        Text("Слов \(text.count)")
                            .foregroundStyle(DS.Color.textColor)
                            .font(DS.Font.fontText)
                            .padding(.leading, 4)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(DS.Color.navColor)
                .cornerRadius(8)

            }
            .padding(.top, 20)
            //            Text("Осталось проверок: \(vm.remaining) / 5")
            //                .font(.footnote)
            
            PrimaryButton(title: "Проверить") {
                vm.run(text: text)
            }
            .padding(.top, 40)
            .disabled(
                text.count < 100 ||
                vm.remaining == 0 ||
                (vm.state == .running)
            )
            
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
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor)
        .task {
            await vm.loadRemaining()
        }
    }
}

#Preview {
    CheckView()
}
