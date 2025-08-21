//
//  InputField.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI
import Combine

public struct InputField<Label: View>: View {
    @Binding var text: String

    let label: () -> Label
    let placeholder: String
    let keyboardType: UIKeyboardType
    let hintColor: Color = .red
    let validator: ((String) -> String?)?

    @FocusState private var isFocused: Bool
    @StateObject private var validationManager = ValidationManager()

    public init(
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default,
        validator: ((String) -> String?)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.validator = validator
        self.label = label
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            inputRow
            Divider()
            validationText
        }
        .animation(.easeInOut(duration: 0.2), value: validationManager.validationMessage)
        .onAppear {
            validationManager.setValidator(validator)
        }
        .onChange(of: text) { newValue in
            validationManager.validate(newValue)
        }
    }

    @ViewBuilder
    private var inputRow: some View {
        HStack(spacing: 12) {
            label()

            TextField(placeholder, text: $text)
                .font(.system(size: 17))
                .keyboardType(keyboardType)
                .focused($isFocused)

            if isFocused && !text.isEmpty {
                Button(action: clearText) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                }
            }
        }
    }

    @ViewBuilder
    private var validationText: some View {
        if !validationManager.validationMessage.isEmpty {
            Text(validationManager.validationMessage)
                .font(.system(size: 12))
                .foregroundColor(hintColor)
                .transition(.opacity)
        }
    }

    private func clearText() {
        text = ""
        validationManager.validate("")
    }
}

// MARK: - Convenience Initializers
extension InputField where Label == EmptyView {
    public init(
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default,
        validator: ((String) -> String?)? = nil
    ) {
        self.init(
            text: text,
            placeholder: placeholder,
            keyboardType: keyboardType,
            validator: validator
        ) {
            EmptyView()
        }
    }
}

// MARK: - Validation Manager
final class ValidationManager: ObservableObject {
    @Published var validationMessage: String = ""

    private var validator: ((String) -> String?)?
    private let inputSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupValidationPipeline()
    }

    func setValidator(_ validator: ((String) -> String?)?) {
        self.validator = validator
    }

    func validate(_ input: String) {
        inputSubject.send(input)
    }

    private func setupValidationPipeline() {
        inputSubject
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .map { [weak self] input in
                self?.validator?(input) ?? ""
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.validationMessage, on: self)
            .store(in: &cancellables)
    }
}
