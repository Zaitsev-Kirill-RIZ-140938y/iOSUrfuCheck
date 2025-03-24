//
//  CheckViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import Foundation

@MainActor
class CheckViewModel: ObservableObject {
    @Published var result: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func check(text: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await APIService.shared.sendText(text)

            let unique = response.full_response.percent
            let cleanText = response.full_response.text
            let sourceURL = response.full_response.matches.first?.url ?? "—"

            self.result = """
            🧠 Уникальность: \(unique)%
            📎 Источник: \(sourceURL)

            💬 Текст:
            \(cleanText)
            """
        } catch {
            self.errorMessage = "Ошибка: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
