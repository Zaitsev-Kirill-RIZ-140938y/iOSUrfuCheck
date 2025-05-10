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
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Вход")
                    .font(.largeTitle).bold()
                Text("Введите свои учетные данные, чтобы продолжить.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 16) {
                TextField("Почта", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                SecureField("Пароль", text: $password)
                    .textFieldStyle(.roundedBorder)
            }

            Button("Войти") {
                vm.signIn(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.state == .loading)
            
            HStack(spacing: 4) {
                Text("Нет аккаунта?")
                    .font(.body)
                    .foregroundColor(.secondary)
                Button("Регистрация") {
                    onToggleAuth()
                }
                .buttonStyle(.plain)
                .font(.body.bold())
                .foregroundColor(DS.Color.positiveColor)
            }
            .padding(.bottom, 16)

            if case .error(let message) = vm.state {
                Text(message).foregroundColor(.red).font(.footnote)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    SignInView(onToggleAuth: { })
}
