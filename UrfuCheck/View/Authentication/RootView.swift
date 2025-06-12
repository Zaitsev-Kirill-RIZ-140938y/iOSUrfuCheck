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
                AnimationView()
            } else if isAuthenticated {
                TabView {
                    CheckView()
                        .tabItem {
                            Label("Проверка", systemImage: "house.fill")
                        }
                    HistoryView()
                        .tabItem {
                            Label("История", systemImage: "clock.fill")
                        }
                }
                .tint(DS.Color.positiveColor)
                      
            } else {
                AuthContainerView {
                    isAuthenticated = true
                }
            }
        }
        .task {
            let start = Date()

            if let user = Auth.auth().currentUser {
                do {
                    try await user.reload()
                    isAuthenticated = user.isEmailVerified
                } catch {
                    print(error.localizedDescription)
                    isAuthenticated = false
                }
            } else {
                isAuthenticated = false
            }

            let elapsed = Date().timeIntervalSince(start)
            let remaining = max(0, 3 - elapsed)

            try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))

            isCheckingAuth = false
        }
    }
}
