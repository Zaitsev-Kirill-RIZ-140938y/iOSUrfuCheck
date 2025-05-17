//
//  MockPlagiarismService.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 17.05.2025.
//

import Foundation

/// Мок-реализация протокола, возвращает фейковые данные сразу
final class MockPlagiarismService: PlagiarismServiceProtocol {
    enum Scenario {
        case alwaysClean      // всегда чисто
        case alwaysPlagiarized // всегда плагиат
        case random            // рандом
    }

    private let scenario: Scenario
    private let delay: UInt64

    /// - parameter delay: задержка в наносекундах для показа ProgressView
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
        let isPlag = (scenario == .alwaysPlagiarized)
                   || (scenario == .random && Bool.random())
        let unique = isPlag
            ? Double.random(in: 0...50)    // низкая уникальность
            : Double.random(in: 90...100)  // высокая уникальность
        return CheckResponse(uid: uid, textUnique: unique)
    }

    func remaining() async throws -> Int {
        try await Task.sleep(nanoseconds: delay)
        return 10
    }
}
