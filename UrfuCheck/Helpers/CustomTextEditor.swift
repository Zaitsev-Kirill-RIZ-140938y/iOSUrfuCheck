//
//  CustomTextEditor.swift
//  UrfuCheck
//
//  Created by Кирилл Зайцев on 24.03.2025.
//

import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String

    var body: some View {
        ZStack {
            WrappedTextView(text: $text)
        }
        // размер
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        // счётчик слов внизу справа
        .overlay(
            HStack {
                Text("\(text.split { $0.isWhitespace }.filter { !$0.isEmpty }.count) слов")
                    .foregroundColor(DS.Color.positiveColor)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
            }
        )
    }
}

struct WrappedTextView: UIViewRepresentable {
  @Binding var text: String

  func makeUIView(context: Context) -> UITextView {
    let tv = UITextView()
      tv.backgroundColor = UIColor(DS.Color.navColor)
      tv.textColor = UIColor(DS.Color.titleColor)
      tv.font = UIFont.preferredFont(forTextStyle: .body)
      tv.delegate = context.coordinator
    // важный момент — внутренние отступы
      tv.textContainerInset = UIEdgeInsets(
      top: 20, left: 20, bottom: 10, right: 20
    )
      tv.layer.cornerRadius = 8
      // placeholder label
      let placeholderLabel = UILabel()
      placeholderLabel.text = "Вставьте текст или загрузите файл"
      placeholderLabel.textColor = UIColor(DS.Color.textColor)
      placeholderLabel.font = tv.font
      placeholderLabel.numberOfLines = 0
      placeholderLabel.tag = 999
      placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
      tv.addSubview(placeholderLabel)
      NSLayoutConstraint.activate([
          placeholderLabel.topAnchor.constraint(equalTo: tv.topAnchor, constant: 20),
          placeholderLabel.leadingAnchor.constraint(equalTo: tv.leadingAnchor, constant: 20),
          placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: tv.trailingAnchor, constant: -20)
      ])
    return tv
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    if uiView.text != text {
      uiView.text = text
    }
      if let placeholderLabel = uiView.viewWithTag(999) as? UILabel {
          placeholderLabel.isHidden = !text.isEmpty
      }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
    
  class Coordinator: NSObject, UITextViewDelegate {
    var parent: WrappedTextView
    init(_ parent: WrappedTextView) { self.parent = parent }
    func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
    }
  }
}
