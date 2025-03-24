//
//  APIService.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import Foundation

struct APIService {
    
    static let shared = APIService()

    private init() {}

    func sendText(_ text: String) async throws -> CheckResponse {
        guard text.count < 7000 else {
            throw NSError(
                domain: "ValidationError",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "Слишком длинный текст. Пожалуйста, сократите."]
            )
        }

        guard let url = URL(string: "https://checkurfu.ru/api/v1") else {
            throw URLError(.badURL)
        }

        let jsonString = "{\"text\": \"\(text)\"}"
        let jsonData = jsonString.data(using: .utf8)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode(CheckResponse.self, from: data)
    }
}
