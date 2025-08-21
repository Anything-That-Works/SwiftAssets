//
//  PrimaryButtonStyle.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI
/// A custom button style that defines the appearance and behavior of a primary action button.
///
/// `PrimaryButtonStyle` allows consistent rendering of primary buttons, including support
/// for custom visual properties and a processing/loading indicator.
///
/// It uses a `ButtonStyleDescriptor` to encapsulate styling details such as padding,
/// background color, font, and press feedback.
///
/// ### Example 1:
/// ```swift
/// Button("Submit") {
///     // perform action
/// }
/// .buttonStyle(.primaryButtonStyle(isProcessing: viewModel.isLoading))
/// ```
/// ### Example 2:
/// ```swift
/// Button("Submit") {
///     // Perform action
/// }
/// .buttonStyle(
///     PrimaryButtonStyle(properties: PrimaryButtonProperties(), isProcessing: viewModel.isLoading)
/// )
/// ```
/// ### Parameters:
/// - `properties`: A `ButtonStyleDescriptor` conforming instance
/// - `isProcessing`: A Boolean indicating whether the button should show a loading indicator.

public struct PrimaryButtonStyle: ButtonStyle {
    let properties: ButtonStyleDescriptor
    var isProcessing: Bool = false

    init(properties: ButtonStyleDescriptor, isProcessing: Bool) {
        self.properties = properties
        self.isProcessing = isProcessing
    }

    @Environment(\.isEnabled) private var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            if isProcessing && isEnabled {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(height: 17)
                    .transition(.opacity)
            }
        }
        .font(properties.font)
        .padding(.vertical, properties.verticalPadding)
        .padding(.horizontal, properties.horizontalPadding)
        .frame(maxWidth: properties.expandToFill ? .infinity : nil)
        .background(currentBackground)
        .foregroundColor(isEnabled ? properties.foregroundColor : properties.disabledForegroundColor)
        .clipShape(RoundedRectangle(cornerRadius: properties.cornerRadius, style: .continuous))
        .scaleEffect(configuration.isPressed && isEnabled ? properties.pressedScale : 1.0)
        .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.2), value: isProcessing)
    }

    private var currentBackground: Color {
        if !isEnabled {
            return properties.disabledBackgroundColor
        } else if isProcessing {
            return properties.processingBackgroundColor
        } else {
            return properties.backgroundColor
        }
    }
}

#Preview {
    Button {
        print("Tapped")
    } label: {
        Text("Primary Button")
    }
    .buttonStyle(.primaryButton())
    
    Button {
        print("Tapped")
    } label: {
        Text("Primary Button")
    }
    .buttonStyle(.primaryButton())
    .disabled(true)
    
    Button {
        print("Tapped")
    } label: {
        Text("Primary Button")
    }
    .buttonStyle(.primaryButton(isProcessing: true))
    
    Button {
        print("Tapped")
    } label: {
        Text("Primary Button")
    }
    .buttonStyle(.primaryButton(isProcessing: true))
    .disabled(true)
}
