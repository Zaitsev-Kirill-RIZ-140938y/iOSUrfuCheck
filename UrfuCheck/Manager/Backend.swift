//
//  Backend.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import Foundation
import FirebaseAuth

struct SubmitResponse: Decodable {
    let uid: String
    let remaining: Int
}

struct CheckResponse: Decodable, Equatable, Identifiable {
    let id = UUID()
    let uid: String
    let clearText: String
    let textUnique: Double?
    let jsonResult: JsonResult?

    enum CodingKeys: String, CodingKey {
        case uid
        case textUnique = "text_unique"
        case clearText  = "clear_text" // ← маппинг
        case jsonResult = "json_result"
    }
}

struct JsonResult: Decodable, Equatable {
    let dateCheck: String?
    let unique: Double?
    let urls: [PlagiarismUrl]?

    enum CodingKeys: String, CodingKey {
        case dateCheck = "date_check"
        case unique
        case urls
    }
}

struct PlagiarismUrl: Decodable, Identifiable, Equatable {
    let id = UUID()
    let url: String
    let plagiat: Double
    let words: String?

    enum CodingKeys: String, CodingKey {
        case url
        case plagiat
        case words
    }
}

protocol PlagiarismServiceProtocol {
    func submit(text: String) async throws -> SubmitResponse
    func poll(for uid: String) async throws -> CheckResponse
    func remaining() async throws -> Int
}

/// Обёртка для сервиса проверки плагиата с автоматическим фоллбэком при потере соединения
final class PlagiarismService: PlagiarismServiceProtocol {
    static let shared = PlagiarismService()
    private let baseURL = URL(string: "https://urfucheck-worker.iflyzed.workers.dev")!

    /// Базовая сессия: ждёт готовности сети, разрешает LTE/Wi-Fi/VPN/Relay
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsExpensiveNetworkAccess   = true
        config.allowsConstrainedNetworkAccess = true
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest  = 60
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }()

    func submit(text: String) async throws -> SubmitResponse {
        try await withRetry(retries: 2, delay: 1_000_000_000) {
            let token = try await Auth.auth().currentUser?.getIDToken() ?? ""
            print("Токен отсутствует? ", token.isEmpty)

            var request = URLRequest(url: baseURL.appendingPathComponent("submitText"))
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(["text": text])

            let (data, response) = try await perform(request)
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("Submit → status = \(code), response = \(String(data: data, encoding: .utf8) ?? "nil")")
            return try JSONDecoder().decode(SubmitResponse.self, from: data)
        }
    }

    func poll(for uid: String) async throws -> CheckResponse {
        try await withRetry(retries: 2, delay: 1_000_000_000) {
            let url = baseURL
                .appendingPathComponent("result")
                .appending(queryItems: [.init(name: "uid", value: uid)])

            while true {
                let (data, response) = try await perform(url)
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                print("Poll → status = \(code), body = \(String(data: data, encoding: .utf8) ?? "nil")") // <-- ВОТ ЭТА СТРОКА!

                if code == 200 {
                    return try JSONDecoder().decode(CheckResponse.self, from: data)
                } else if code != 202 {
                    throw URLError(.badServerResponse)
                }
                try await Task.sleep(nanoseconds: 3_000_000_000)
            }
        }
    }

    func remaining() async throws -> Int {
        try await withRetry(retries: 2, delay: 1_000_000_000) {
            let token = try await Auth.auth().currentUser?.getIDToken() ?? ""
            var request = URLRequest(url: baseURL.appendingPathComponent("remaining"))
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, _) = try await perform(request)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json?["remaining"] as? Int ?? 0
        }
    }

    private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch let err as URLError where err.code == .networkConnectionLost {
            // Фоллбэк на стандартную сессию
            return try await URLSession.shared.data(for: request)
        }
    }

    private func perform(_ url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(from: url)
        } catch let err as URLError where err.code == .networkConnectionLost {
            // Фоллбэк на стандартную сессию
            return try await URLSession.shared.data(from: url)
        }
    }
}

private extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url ?? self
    }
}

extension PlagiarismService {
    private func withRetry<T>(
        retries: Int = 3,
        delay: UInt64 = 1_000_000_000,
        task: () async throws -> T
    ) async throws -> T {
        var lastError: Error!
        for attempt in 1...retries {
            do {
                return try await task()
            } catch {
                lastError = error
                if attempt == retries { break }
                try? await Task.sleep(nanoseconds: delay)
            }
        }
        throw lastError
    }
}
