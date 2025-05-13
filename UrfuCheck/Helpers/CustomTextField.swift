//
//  CustomTextField.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 13.05.2025.
//

import SwiftUI

struct CustomTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    
    var iconWidth: CGFloat = 19
    var iconHeight: CGFloat = 22

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(DS.Color.positiveColor)
                .frame(width: iconWidth, height: iconHeight)

            TextField("", text: $text)
                .foregroundColor(DS.Color.titleColor)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(DS.Color.titleColor)
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(DS.Color.fonColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(DS.Color.positiveColor, lineWidth: 2)
        )
    }
}

struct SecureTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure = true

    var iconWidth: CGFloat = 19
    var iconHeight: CGFloat = 22
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(DS.Color.positiveColor)
                .frame(width: iconWidth, height: iconHeight)
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .foregroundColor(DS.Color.titleColor)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(DS.Color.titleColor)
            }
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .onChange(of: text) { newValue in
                text = newValue.filter { $0.isASCII }
            }
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(DS.Color.positiveColor)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(DS.Color.fonColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(DS.Color.positiveColor, lineWidth: 2)
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                content()
            }
            self
        }
    }
}
