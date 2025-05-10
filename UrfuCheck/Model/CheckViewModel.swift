//
//  CheckVM.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 10.05.2025.
//

import SwiftUI

@MainActor
final class CheckVM: ObservableObject {
    enum State {
            case idle
            case running
            case done(Double)
            case error(String)
        }

    @Published var remaining = 5
    @Published var state: State = .idle

    func run(text: String) {
        Task {
            do {
                state = .running
                let resp = try await Backend.shared.submit(text: text)
                remaining = resp.remaining          // обновили счётчик
                let result = try await Backend.shared.poll(uid: resp.uid)
                state = .done(result.text_unique)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
