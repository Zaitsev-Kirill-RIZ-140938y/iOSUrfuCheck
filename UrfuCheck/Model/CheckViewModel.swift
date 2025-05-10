//
//  CheckViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 09.05.2025.
//

import Foundation

@MainActor
final class CheckViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case running
        case done(Double)
        case error(String)
    }

    @Published var remaining = 5
    @Published var state: State = .idle

    private let service: PlagiarismServiceProtocol

    init(service: PlagiarismServiceProtocol = PlagiarismService.shared) {
        self.service = service
    }

    /// Запускает проверку уникальности текста
    func run(text: String) {
        Task {
            do {
                state = .running
                let resp = try await service.submit(text: text)
                remaining = resp.remaining

                let result = try await service.poll(for: resp.uid)
                print("✅ DONE, уникальность = \(result.textUnique)")

                // Обновляем state на главном потоке
                DispatchQueue.main.async {
                    self.state = .done(result.textUnique)
                }
            } catch {
                print("❌ Error in run():", error.localizedDescription)
                DispatchQueue.main.async {
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }

    /// Загружает текущее количество оставшихся проверок
    func loadRemaining() async {
        do {
            let count = try await service.remaining()
            self.remaining = count
        } catch {
            // В случае ошибки показываем сообщение
            self.state = .error(error.localizedDescription)
        }
    }
}
