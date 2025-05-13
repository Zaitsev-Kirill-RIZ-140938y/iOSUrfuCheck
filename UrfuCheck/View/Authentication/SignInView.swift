//
//  SignInView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @StateObject private var vm = SignInViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    var onToggleAuth: () -> Void
    var onAuthSuccess: () -> Void = {}
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                Text("Вход")
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
                    iconName: "envelope.fill",
                    placeholder: "Почта",
                    text: $email,
                    iconWidth: 19,
                    iconHeight: 22
                )
                SecureTextField(
                    iconName: "lock.fill",
                    placeholder: "Пароль",
                    text: $password,
                    iconWidth: 19,
                    iconHeight: 22
                )
            }
            
            PrimaryButton(title: "Войти") {
                vm.signIn(email: email, password: password)
            }
            .padding(.top, 40)
            
            HStack {
                Text("Нет аккаунта?")
                    .font(DS.Font.fontText)
                    .fontWeight(.bold)
                    .foregroundColor(DS.Color.titleColor)
                
                Spacer()
                
                Button("Зарегистрироваться") {
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
    SignInView(onToggleAuth: { })
}
