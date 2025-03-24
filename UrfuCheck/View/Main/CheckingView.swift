//
//  CheckingView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI

struct CheckingView: View {
    
    @StateObject private var viewModel = CheckViewModel()
    @State private var inputText = ""
    
    init() {
            UITextView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        VStack {
            Text("Проверка на плагиат")
                .font(DS.Font.fontTitleHead)
                .foregroundColor(DS.Color.titleColor)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            CustomTextEditor(
                text: $inputText,
                textColor: DS.UIColors.titleColor,
                backgroundColor: DS.UIColors.navColor,
                font: DS.UIFonts.fontText
            )
            .frame(height: 400)
            .padding(.bottom, 40)
            
            PrimaryButton(title: "Проверить") {
                await viewModel.check(text: inputText)
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
        .background(DS.Color.fonColor)
    }
}

#Preview {
    CheckingView()
}
