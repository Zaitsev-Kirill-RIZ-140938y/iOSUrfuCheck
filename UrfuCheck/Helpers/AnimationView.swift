//
//  AnimationView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 17.05.2025.
//

import SwiftUI
import DotLottie

struct AnimationView: View {
    var body: some View {
        ZStack {
            // белый фон на весь экран
            Color.white
                .ignoresSafeArea()

            // ваша анимация
            DotLottieAnimation(
                fileName: "AnimationLogo",
                config: AnimationConfig(autoplay: true)
            )
            .view()
        }
    }
}
