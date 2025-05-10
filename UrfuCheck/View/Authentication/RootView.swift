//
//  RootView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var isAuthenticated = false
    @State private var isCheckingAuth = true

    var body: some View {
        Group {
            if isCheckingAuth {
                ProgressView("Загрузка...")
            } else if isAuthenticated {
                CheckView()
            } else {
                SignUpView {
                    isAuthenticated = true
                }
            }
        }
        .task {
            if let user = Auth.auth().currentUser {
                do {
                    try await user.reload()
                    isAuthenticated = user.isEmailVerified
                } catch {
                    print("reload error: \(error.localizedDescription)")
                    isAuthenticated = false
                }
            } else {
                isAuthenticated = false
            }
            isCheckingAuth = false
        }
    }
}
