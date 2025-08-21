//
//  MultilineTextInputView.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import UIKit
import SwiftUI

public struct MultilineTextInputView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var font: UIFont

    public init(text: Binding<String>, placeholder: String = "", font: UIFont = .systemFont(ofSize: 17)) {
        self._text = text
        self.placeholder = placeholder
        self.font = font
    }

    public func makeUIView(context: Context) -> UITextView {
        let view = AutoSizingTextView()
        view.isScrollEnabled = false
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = context.coordinator
        view.font = font
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        view.textContainer.widthTracksTextView = true

        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)

        view.text = text
        view.textColor = .label

        // Setup placeholder immediately
        context.coordinator.setupPlaceholderIfNeeded(for: view)
        context.coordinator.updatePlaceholderVisibility(for: view)

        return view
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        // Update text if it differs from binding
        if uiView.text != text {
            uiView.text = text
            uiView.invalidateIntrinsicContentSize()
        }

        // Update text color based on content
        uiView.textColor = .label
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextInputView
        private var placeholderLabel: UILabel?

        init(_ parent: MultilineTextInputView) {
            self.parent = parent
            super.init()
        }

        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            updatePlaceholderVisibility(for: textView)

            // Trigger layout update to resize the text view
            DispatchQueue.main.async {
                textView.invalidateIntrinsicContentSize()
            }
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            setupPlaceholderIfNeeded(for: textView)
            updatePlaceholderVisibility(for: textView)
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            updatePlaceholderVisibility(for: textView)
        }

        func setupPlaceholderIfNeeded(for textView: UITextView) {
            guard placeholderLabel == nil else { return }

            let placeholder = UILabel()
            placeholder.text = parent.placeholder
            placeholder.font = textView.font
            placeholder.textColor = .placeholderText
            placeholder.numberOfLines = 0
            placeholder.translatesAutoresizingMaskIntoConstraints = false

            textView.addSubview(placeholder)

            NSLayoutConstraint.activate([
                placeholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
                placeholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
                placeholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5)
            ])

            placeholderLabel = placeholder
            updatePlaceholderVisibility(for: textView)
        }

        func updatePlaceholderVisibility(for textView: UITextView) {
            setupPlaceholderIfNeeded(for: textView)

            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}

class AutoSizingTextView: UITextView {
    override var intrinsicContentSize: CGSize {
        let textSize = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        return CGSize(width: UIView.noIntrinsicMetric, height: textSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
