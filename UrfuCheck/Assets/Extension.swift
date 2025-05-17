//
//  Extension.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI
import UIKit

// DS = Design System
enum DS {
    enum Font {
        static let fontTitle1 = SwiftUI.Font.system(size: 34, weight: .bold)
        static let fontTitle3 = SwiftUI.Font.system(size: 20, weight: .regular)
        static let fontTitleHead = SwiftUI.Font.system(size: 22, weight: .bold)
        static let fontText = SwiftUI.Font.system(size: 17, weight: .regular)
    }

    enum UIFonts {
        static let fontTitle1 = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let fontTitle3 = UIFont.systemFont(ofSize: 20, weight: .regular)
        static let fontTitleHead = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let fontText = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Color {
        static let fonColor = SwiftUI.Color(red: 0.086, green: 0.086, blue: 0.118)
        static let titleColor = SwiftUI.Color(red: 0.949, green: 0.949, blue: 0.949)
        static let positiveColor = SwiftUI.Color(red: 0.463, green: 0.78, blue: 0.506)
        static let negativColor = SwiftUI.Color(red: 0.851, green: 0.408, blue: 0.373)
        static let navColor = SwiftUI.Color(red: 0.231, green: 0.231, blue: 0.247)
        static let textColor = SwiftUI.Color(red: 0.424, green: 0.424, blue: 0.424)
    }

    enum UIColors {
        static let fonColor = UIColor(red: 0.086, green: 0.086, blue: 0.118, alpha: 1)
        static let titleColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        static let positiveColor = UIColor(red: 0.463, green: 0.78, blue: 0.506, alpha: 1)
        static let negativColor = UIColor(red: 0.463, green: 0.78, blue: 0.506, alpha: 1)
        static let navColor = UIColor(red: 0.231, green: 0.231, blue: 0.247, alpha: 1)
        static let textColor = UIColor(red: 0.424, green: 0.424, blue: 0.424, alpha: 1)
    }
}
