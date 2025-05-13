//
//  SignUPView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @StateObject private var vm = SignUpViewModel()

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var onToggleAuth: () -> Void
    var onAuthSuccess: () -> Void = {}
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                Text("Регистрация")
                    .font(DS.Font.fontTitle1)
                    .foregroundStyle(DS.Color.titleColor)
                Text("Введите свои учетные данные, чтобы продолжить.")
                    .font(DS.Font.fontTitle3)
                    .fontWeight(.bold)
                    .foregroundStyle(DS.Color.titleColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 70)
            .padding(.bottom, 50)
            
            VStack(spacing: 20) {
                CustomTextField(
                    iconName: "person.fill",
                    placeholder: "Имя",
                    text: $name
                )
                CustomTextField(
                    iconName: "envelope.fill",
                    placeholder: "Почта",
                    text: $email
                )
                SecureTextField(
                    iconName: "lock.fill",
                    placeholder: "Пароль",
                    text: $password
                )
            }
            
            PrimaryButton(title: "Зарегистрироваться") {
                vm.signUp(name: name, email: email, password: password)
            }
            .padding(.top, 40)
            
            HStack {
                Text("Уже зарегистрированы?")
                    .font(DS.Font.fontText)
                    .fontWeight(.bold)
                    .foregroundColor(DS.Color.titleColor)
                
                Spacer()
                
                Button("Войти") {
                    onToggleAuth()
                }
                .buttonStyle(.plain)
                .font(DS.Font.fontText)
                .fontWeight(.bold)
                .foregroundColor(DS.Color.positiveColor).bold()
            }
            .padding(.horizontal, 16)
            .padding(.top, 62)
            
            if case .error(let message) = vm.state {
                Text(message).foregroundColor(.red).font(.footnote)
            } else if vm.state == .emailVerificationSent {
                Text("Письмо с подтверждением отправлено на почту.")
                    .foregroundColor(.green).font(.footnote)
            }
            Spacer()
        }
        .onChange(of: vm.state) { state in
            if state == .idle {
                onAuthSuccess()
            }
        }
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor)
    }
}

#Preview {
    SignUpView(onToggleAuth: { })
}
