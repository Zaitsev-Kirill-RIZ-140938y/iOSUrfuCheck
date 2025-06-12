//
//  CheckViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 09.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class CheckViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case running
        case done(CheckResponse)
        case error(String)
    }

    @Published var remaining = 5
    @Published var state: State = .idle

    private let service: PlagiarismServiceProtocol

    init(service: PlagiarismServiceProtocol = PlagiarismService.shared) {
        self.service = service
    }

    func run(text: String) {
        Task {
            do {
                state = .running
                let resp = try await service.submit(text: text)
                remaining = resp.remaining

                let result = try await service.poll(for: resp.uid)
                print("✅ DONE, уникальность = \(result.jsonResult?.unique ?? 0)")

                // Обновляем state на главном потоке
                DispatchQueue.main.async {
                    self.state = .done(result)
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

final class HistoryService {
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    /// Сохранить CheckResponse в коллекцию "history"
    func save(_ response: CheckResponse) async throws {
        guard let userId = userId else { throw URLError(.userAuthenticationRequired) }
        let data: [String: Any] = [
            "uid": response.uid,
            "clearText": response.clearText,
            "textUnique": response.textUnique ?? 0,
            "jsonResult": [
                "unique": response.jsonResult?.unique ?? 0,
                "dateCheck": FieldValue.serverTimestamp(),
                "urls": response.jsonResult?.urls?.map { [
                    "url": $0.url,
                    "plagiat": $0.plagiat,
                    "words": $0.words ?? ""
                ] } ?? []
            ]
        ]
        try await db
            .collection("users")
            .document(userId)
            .collection("history")
            .document(response.uid)
            .setData(data)
    }
}
