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
        defer { isLoading = false }

        do {
            let resp = try await APIService.shared.sendText(text)

            // если бек вернул error != ""
            if !resp.error.isEmpty {
                throw APIError.backendError(resp.error)
            }

            // превращаем строку "0.0" или "87,4" в Double
            let percentValue = Double(resp.percent.replacingOccurrences(of: ",", with: ".")) ?? 0

            // первый источник, если есть
            let source = resp.matches.first?.url ?? "—"

            result = """
            🧠 Уникальность: \(String(format: "%.2f", percentValue)) %
            📎 Источник: \(source)

            💬 Текст:
            \(resp.text)
            """
        } catch {
            // Показываем понятную ошибку
            errorMessage = error.localizedDescription
        }
    }
}
