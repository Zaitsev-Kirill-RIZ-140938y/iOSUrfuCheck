//
//  APIService.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import Foundation

// ── Ответ от API ровно «как есть» ──
struct CheckResponse: Decodable {
    let text: String
    let percent: String
    let highlight: [[String]]
    let matches: [Match]
    let error: String
    let error_code: Int
}

struct Match: Decodable {
    let url: String
    let percent: String
    let highlight: [[String]]
}

// ── Ошибки клиента ──
enum APIError: LocalizedError {
    case tooLong
    case invalidURL
    case badStatus(Int)
    case emptyBody
    case backendError(String)
    case decodeError(String)

    var errorDescription: String? {
        switch self {
        case .tooLong:           return "Слишком длинный текст — сократите."
        case .invalidURL:        return "Неверный адрес API."
        case .badStatus(let c):  return "Сервер вернул статус \(c)."
        case .emptyBody:         return "Пустой ответ от сервера."
        case .backendError(let msg): return msg
        case .decodeError(let msg):  return "Не удалось разобрать ответ: \(msg)"
        }
    }
}

// ── Сервис ──
struct APIService {
    static let shared = APIService()
    private init() {}

    func sendText(_ text: String) async throws -> CheckResponse {
        // 1) длина
        guard text.count < 7000 else { throw APIError.tooLong }

        // 2) URL
        guard let url = URL(string: "https://checkurfu.ru/api/v1") else {
            throw APIError.invalidURL
        }

        // 3) JSON‑тело
        let body = ["text": text]
        let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json",                 forHTTPHeaderField: "Accept")
        req.httpBody = bodyData

        // 4) отправляем
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw APIError.badStatus(-1)
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.badStatus(http.statusCode)
        }
        guard !data.isEmpty else {
            throw APIError.emptyBody
        }

        // 5) декодим ровно в наши модели
        do {
            return try JSONDecoder().decode(CheckResponse.self, from: data)
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes>"
            // для отладки
            print("❌ RAW RESPONSE:\n\(raw)")
            throw APIError.decodeError(error.localizedDescription)
        }
    }
}
