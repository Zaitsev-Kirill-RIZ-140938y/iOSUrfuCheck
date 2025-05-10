//
//  SignUpViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 09.05.2025.
//

import Foundation
import FirebaseAuth

@MainActor
final class SignUpViewModel: ObservableObject {
    
    enum State: Equatable {
        case idle
        case loading
        case emailVerificationSent
        case error(String)
    }
    
    @Published var state: State = .idle
    
    func signUp(name: String, email: String, password: String) {
        state = .loading
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                let change = result.user.createProfileChangeRequest()
                change.displayName = name
                try await change.commitChanges()
                try await result.user.sendEmailVerification()
                
                state = .emailVerificationSent
                print("✅ Email sent")
                
                while true {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    
                    guard let user = Auth.auth().currentUser else {
                        print("⚠️ user == nil")
                        continue
                    }
                    
                    try await user.reload()
                    print("🔄 isEmailVerified = \(user.isEmailVerified)")
                    
                    if user.isEmailVerified {
                        print("✅ Email verified")
                        state = .idle
                        break
                    }
                }
                
            } catch {
                print("❌ SignUp error:", error.localizedDescription)
                state = .error(error.localizedDescription)
            }
        }
    }
}
