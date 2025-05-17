//
//  AuthContainerView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 12.05.2025.
//

import SwiftUI

struct AuthContainerView: View {
    @State private var showLogin = true
    var onAuthSuccess: () -> Void
    
    var body: some View {
        Group {
            if showLogin {
                SignInView(
                    onToggleAuth: { showLogin = false },
                    onAuthSuccess: onAuthSuccess
                )
            } else {
                SignUpView(
                    onToggleAuth: { showLogin = true },
                    onAuthSuccess: onAuthSuccess
                )
            }
        }
        .animation(.easeInOut, value: showLogin)
        .transition(.slide)
    }
}

#Preview {
    AuthContainerView(onAuthSuccess: { })
}
