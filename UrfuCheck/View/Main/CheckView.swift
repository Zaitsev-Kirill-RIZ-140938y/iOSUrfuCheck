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
    @FocusState private var editorFocused: Bool
    
    @State private var checkResponse: CheckResponse? = nil
    
    init() {
#if DEBUG
        // В DEBUG используем мок-сервис
        _vm = StateObject(
            wrappedValue: CheckViewModel(
                service: MockPlagiarismService(scenario: .random)
            )
        )
#else
        // В релизе — реальный сервис
        _vm = StateObject(
            wrappedValue: CheckViewModel()
        )
#endif
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                Text("Проверка на плагиат")
                    .font(DS.Font.fontTitleHead)
                    .foregroundStyle(DS.Color.titleColor)
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Введите текст для проверки")
                            .foregroundStyle(DS.Color.textColor)
                            .font(DS.Font.fontText)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    
                    TextEditor(text: $text)
                        .focused($editorFocused)
                        .scrollDismissesKeyboard(.interactively)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(DS.Color.titleColor)
                        .font(DS.Font.fontText)
                        .padding(.bottom, 50)
                    
                    VStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Text("Слов")
                                .foregroundStyle(DS.Color.titleColor)
                                .font(DS.Font.fontText)
                                .fontWeight(.bold)
                                .padding(.leading, 4)
                            Text("\(text.count)")
                                .foregroundColor(DS.Color.positiveColor)
                                .font(DS.Font.fontText)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if !text.isEmpty {
                                Button(action: { text = "" }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(DS.Color.negativColor)
                                }
                            }
                            
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(DS.Color.navColor)
                .cornerRadius(8)
                
            }
            .padding(.top, 20)
            
            PrimaryButton(title: "Проверить") {
                vm.run(text: text)
            }
            .padding(.top, 40)
            
            switch vm.state {
            case .running:
                ProgressView("Проверяем текст...")
                    .padding(.top, 40)
                    .font(DS.Font.fontTitle3)
                    .foregroundStyle(DS.Color.titleColor)
            case .done:
                EmptyView()
            case .error(let msg):
                Text("Ошибка: \(msg)")
            default:
                EmptyView()
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor)
        .onTapGesture {
            editorFocused = false
        }
        .onAppear {
            Task { await vm.loadRemaining() }
        }
        .tint(DS.Color.positiveColor)
        .onChange(of: vm.state) { newState in
            if case .done(let response) = newState {
                checkResponse = response
                Task {
                    do {
                        try await HistoryService().save(response)
                    } catch {
                        print("Не удалось сохранить в историю:", error)
                    }
                }
            } else {
                checkResponse = nil
            }
        }
        .sheet(item: $checkResponse, onDismiss: {
            checkResponse = nil
        }) { response in
            ResultCheckView(response: response)
        }
    }
}

#Preview {
    CheckView()
}

