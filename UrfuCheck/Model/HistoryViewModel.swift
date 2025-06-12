//
//  HistoryViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 12.06.2025.
//

//
//  HistoryViewModel.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 12.06.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var items: [CheckResponse] = []
    @Published var isLoading: Bool = false

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func loadHistory() async {
        guard let userId = userId else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("history")
                .order(by: "jsonResult.dateCheck", descending: true)
                .getDocuments()

            self.items = try snapshot.documents.map { doc in
                let data = doc.data()
                // Декодим проверку так же, как ранее
                let json = data["jsonResult"] as? [String: Any] ?? [:]
                let urlsData = json["urls"] as? [[String: Any]] ?? []
                let urls = urlsData.map { d in
                    PlagiarismUrl(
                        url: d["url"] as! String,
                        plagiat: d["plagiat"] as! Double,
                        words: d["words"] as? String
                    )
                }
                let jr = JsonResult(
                    dateCheck: (json["dateCheck"] as? Timestamp)?
                                  .dateValue()
                                  .formatted(date: .numeric, time: .shortened),
                    unique: json["unique"] as? Double,
                    urls: urls
                )
                return CheckResponse(
                    uid: data["uid"] as! String,
                    clearText: data["clearText"] as! String,
                    textUnique: data["textUnique"] as? Double,
                    jsonResult: jr
                )
            }
        } catch {
            print("Ошибка загрузки истории:", error)
        }
    }
}
