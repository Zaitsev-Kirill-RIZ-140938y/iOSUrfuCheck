//
//  SignUPView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI

struct SignUPView: View {
    
    @State private var nameComponents = PersonNameComponents()
    
    var body: some View {
      
        VStack {
            Text("Регистрация")
        }
    }
}

#Preview {
    SignUPView()
}
