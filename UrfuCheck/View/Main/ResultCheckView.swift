//
//  ResultCheckView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 14.05.2025.
//

import SwiftUI

struct ResultCheckView: View {
    /// уникальность от 0 до 1
    let unique: Double

    private var clamped: Double { max(0, min(1, unique)) }
    private var percentUnique: Int { Int(clamped * 100) }
    private var percentPlagiarism: Int { 100 - percentUnique }

    var body: some View {
        VStack(spacing: 30) {
            // Заголовок
            Text("Проверка на плагиат")
                .font(DS.Font.fontTitleHead)
                .foregroundStyle(DS.Color.titleColor)
                .padding(.top, 30)

            // Результат в карточке
            HStack(spacing: 16) {
                // Круг-диаграмма с процентом внутри
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(DS.Color.negativColor, lineWidth: 12)
                    Circle()
                        .trim(from: 0, to: clamped)
                        .stroke(DS.Color.positiveColor, lineWidth: 12)
                        .rotationEffect(.degrees(-90))
                    // Процент уникальности
                    Text("\(percentUnique)%")
                        .font(DS.Font.fontTitleHead)
                        .foregroundStyle(DS.Color.positiveColor)
                }
                .frame(width: 80, height: 80)

                // Текстовые проценты справа
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Capsule()
                            .fill(DS.Color.positiveColor)
                            .frame(width: 4, height: 16)
                        Text("\(percentUnique)% Уникально")
                            .foregroundStyle(DS.Color.titleColor)
                            .font(DS.Font.fontText)
                    }
                    HStack(spacing: 4) {
                        Capsule()
                            .fill(DS.Color.negativColor)
                            .frame(width: 4, height: 16)
                        Text("\(percentPlagiarism)% Плагиат")
                            .foregroundStyle(DS.Color.titleColor)
                            .font(DS.Font.fontText)
                    }
                }
                Spacer()
            }
            .padding(16)
            .background(DS.Color.navColor)
            .cornerRadius(12)

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ResultCheckView(unique: 0.5)
}
