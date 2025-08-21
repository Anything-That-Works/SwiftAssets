//
//  ButtonStyleDescriptor.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI

/// A protocol that defines the visual and interactive styling options for a custom button.
///
/// Conforming types specify how buttons should appear and respond to user interaction,
/// such as text styling, padding, colors, and press effects.
///
/// ### Properties:
/// - `font`: The font used for the button’s text content.
/// - `verticalPadding`: The vertical padding applied to the button’s content.
/// - `horizontalPadding`: The horizontal padding applied to the button’s content.
/// - `expandToFill`: A Boolean value indicating whether the button should expand to fill its container.
/// - `cornerRadius`: The corner radius applied to the button’s background.
/// - `backgroundColor`: The background color of the button in its normal state.
/// - `processingBackgroundColor`: The background color of the button when an action is in progress.
/// - `foregroundColor`: The foreground color of the button (usually text or icon).
/// - `disabledBackgroundColor`: The background color of the button when disabled.
/// - `disabledForegroundColor`: The foreground color of the button when disabled.
/// - `pressedOpacity`: The opacity applied when the button is actively pressed.
/// - `pressedScale`: The scale transformation applied when the button is pressed.
public protocol ButtonStyleDescriptor {
    var font: Font { get }

    // MARK: Sizing properties
    var verticalPadding: CGFloat { get }
    var horizontalPadding: CGFloat { get }
    var expandToFill: Bool { get }
    var cornerRadius: CGFloat { get }

    // MARK: Color Properties
    var backgroundColor: Color { get }
    var processingBackgroundColor: Color { get }
    var foregroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var disabledForegroundColor: Color { get }

    // MARK: On press properties
    var pressedOpacity: Double { get }
    var pressedScale: CGFloat { get }
}
