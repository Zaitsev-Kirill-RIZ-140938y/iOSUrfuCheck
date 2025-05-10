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

struct CheckResponse: Decodable {
    let uid: String
    let textUnique: Double

    enum CodingKeys: String, CodingKey {
        case uid
        case textUnique = "text_unique"
    }
}

protocol PlagiarismServiceProtocol {
    func submit(text: String) async throws -> SubmitResponse
    func poll(for uid: String) async throws -> CheckResponse
    func remaining() async throws -> Int
}

final class PlagiarismService: PlagiarismServiceProtocol {
    static let shared = PlagiarismService()

    private let baseURL = URL(string: "https://urfucheck-worker.iflyzed.workers.dev")!

    func submit(text: String) async throws -> SubmitResponse {
        let token = try await Auth.auth().currentUser?.getIDToken() ?? ""
        var request = URLRequest(url: baseURL.appendingPathComponent("submitText"))
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["text": text])

        let (data, response) = try await URLSession.shared.data(for: request)
        let code = (response as? HTTPURLResponse)?.statusCode ?? 0
        print("📤 submit → status = \(code), response = \(String(data: data, encoding: .utf8) ?? "nil")")

        return try JSONDecoder().decode(SubmitResponse.self, from: data)
    }

    func poll(for uid: String) async throws -> CheckResponse {
        let url = baseURL.appendingPathComponent("result").appending(queryItems: [.init(name: "uid", value: uid)])
        while true {
            let (data, response) = try await URLSession.shared.data(from: url)
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            let raw = String(data: data, encoding: .utf8) ?? "nil"

            print("📡 poll → status = \(code), body = \(raw)")

            if code == 200 {
                do {
                    let result = try JSONDecoder().decode(CheckResponse.self, from: data)
                    return result
                } catch {
                    print("❌ decode error:", error.localizedDescription)
                    throw error
                }
            } else if code != 202 {
                throw URLError(.badServerResponse)
            }

            try await Task.sleep(nanoseconds: 3_000_000_000)
        }
    }
    
    func remaining() async throws -> Int {
        let token = try await Auth.auth().currentUser?.getIDToken() ?? ""
        var request = URLRequest(url: baseURL.appendingPathComponent("remaining"))
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        return json?["remaining"] as? Int ?? 0
    }
}

private extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        components.queryItems = queryItems
        return components.url ?? self
    }
}
