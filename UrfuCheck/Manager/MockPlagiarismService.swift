//
//  MockPlagiarismService.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 17.05.2025.
//

import Foundation

final class MockPlagiarismService: PlagiarismServiceProtocol {
    enum Scenario {
        case alwaysClean      // всегда чисто
        case alwaysPlagiarized // всегда плагиат
        case random            // рандом
    }
    
    private let sampleUrls = [
        "https://en.wikipedia.org/wiki/Wikipedia",
        "https://habr.com/ru/articles/101010/",
        "https://text.ru/",
        "https://vc.ru/u/12345"
    ]

    private let scenario: Scenario
    private let delay: UInt64

    init(scenario: Scenario = .random,
         delay: UInt64 = 200_000_000) // 0.2 секунды
    {
        self.scenario = scenario
        self.delay = delay
    }

    func submit(text: String) async throws -> SubmitResponse {
        try await Task.sleep(nanoseconds: delay)
        // возвращаем фейковый UID и «остаток» пакета
        return SubmitResponse(uid: "mock-\(Int.random(in: 1...1000))", remaining: 10)
    }

    func poll(for uid: String) async throws -> CheckResponse {
        try await Task.sleep(nanoseconds: delay)

        let unique = Double.random(in: 70...100)
        let countWords = 100
        let plagWords = (0..<countWords).compactMap { i in Bool.random() ? "\(i)" : nil }.joined(separator: " ")
        let urlCount = Int.random(in: 1...2)
        let urls = (0..<urlCount).map { _ in
            PlagiarismUrl(
                url: sampleUrls.randomElement()!,
                plagiat: Double(Int.random(in: 10...90)),
                words: plagWords
            )
        }

        let jsonResult = JsonResult(
            dateCheck: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short),
            unique: unique,
            urls: urls
        )

        return CheckResponse(
            uid: uid,
            clearText: "Mock clear text …",   // ← теперь требуется
            textUnique: unique,
            jsonResult: jsonResult
        )
    }


    // Перенес внутрь класса!
    func remaining() async throws -> Int {
        try await Task.sleep(nanoseconds: delay)
        return 10
    }
}
