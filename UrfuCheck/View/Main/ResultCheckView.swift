//
//  ResultCheckView.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 14.05.2025.
//

import SwiftUI

struct ResultCheckView: View {
    /// уникальность от 0 до 100
    let unique: Double
    
    // Переводим значение в [0,1]
    private var fraction: Double { max(0, min(1, unique / 100)) }
    private var percentUnique: Int { Int(fraction * 100) }
    private var percentPlagiarism: Int { 100 - percentUnique }
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                Text("Результат проверки")
                    .font(DS.Font.fontTitleHead)
                    .foregroundStyle(DS.Color.titleColor)
                    .padding(.top, 20)
                HStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(DS.Color.negativColor, lineWidth: 12)
                        Circle()
                            .trim(from: 0, to: fraction)
                            .stroke(DS.Color.positiveColor, lineWidth: 12)
                            .rotationEffect(.degrees(-90))
                        Text("\(percentUnique)%")
                            .font(DS.Font.fontTitleHead)
                            .foregroundStyle(DS.Color.positiveColor)
                    }
                    .frame(maxWidth: 90, maxHeight: 90)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Capsule()
                                .fill(DS.Color.positiveColor)
                                .frame(width: 4, height: 16)
                            Text("\(percentUnique)% Уникально")
                                .foregroundStyle(DS.Color.titleColor)
                                .font(DS.Font.fontText)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Capsule()
                                .fill(DS.Color.negativColor)
                                .frame(width: 4, height: 16)
                            Text("\(percentPlagiarism)% Плагиат")
                                .foregroundStyle(DS.Color.titleColor)
                                .font(DS.Font.fontText)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(20)
                .background(DS.Color.navColor)
                .cornerRadius(12)
                
                
                Picker(selection: .constant(1), label: Text("Picker")) {
                    Text("Плагиат").tag(1)
                    Text("URL Источник").tag(2)
                }
                .pickerStyle(.segmented)
                .tint(DS.Color.positiveColor)
                
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(DS.Color.fonColor)
    }
}

#Preview {
    ResultCheckView(unique: 0.5)
}
