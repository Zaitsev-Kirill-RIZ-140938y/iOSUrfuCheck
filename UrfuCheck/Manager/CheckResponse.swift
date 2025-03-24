//
//  CheckResponse.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

struct CheckResponse: Codable {
    let error: String
    let full_response: FullResponse
}

struct FullResponse: Codable {
    let error: String
    let error_code: Int
    let text: String
    let percent: String
    let highlight: [[String]]
    let matches: [Match]
}

struct Match: Codable {
    let url: String
    let percent: String
    let highlight: [[String]]
}
