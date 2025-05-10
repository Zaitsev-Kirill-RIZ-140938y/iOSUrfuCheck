//
//  SignInViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import Foundation
import FirebaseAuth

@MainActor
final class SignInViewModel: ObservableObject {
    
    enum State: Equatable {
        case idle
        case loading
        case error(String)
    }

    @Published var state: State = .idle

    func signIn(email: String, password: String) {
        state = .loading
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)

                guard result.user.isEmailVerified else {
                    state = .error("Пожалуйста, подтвердите свою почту перед входом.")
                    return
                }

                state = .idle
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
