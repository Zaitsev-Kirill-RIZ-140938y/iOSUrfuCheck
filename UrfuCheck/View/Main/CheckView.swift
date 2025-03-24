//
//  CheckView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI

struct CheckView: View {
    
    @StateObject private var viewModel = CheckViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Введите текст для проверки:")
                .font(.headline)

            TextEditor(text: $inputText)
                .frame(height: 200)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )

            Button(action: {
                Task {
                    await viewModel.check(text: inputText)
                }
            }) {
                Text("Проверить")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView("Проверка...")
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            if !viewModel.result.isEmpty {
                ScrollView {
                    Text(viewModel.result)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CheckView()
}
