//
//  SocialButtonProperties.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI
/// A concrete implementation of `ButtonStyleDescriptor` defining the default appearance and behavior
/// of a social action button used across the application.
///
/// ### Properties:
/// - `font`: Uses a custom regular font at size 15 for slightly smaller text than primary buttons.
/// - `verticalPadding`: 14 points of vertical padding inside the button.
/// - `horizontalPadding`: Zero horizontal padding to allow flexible content alignment.
/// - `expandToFill`: Button expands to fill available horizontal space.
/// - `cornerRadius`: 8-point rounded corners for a smooth and consistent appearance.
/// - `backgroundColor`: White background color, typical for social login buttons.
/// - `processingBackgroundColor`: White background color used during ongoing actions (e.g., loading).
/// - `foregroundColor`: Black text color in active state for high contrast on white background.
/// - `disabledBackgroundColor`: A light gray background when the button is disabled.
/// - `disabledForegroundColor`: White foreground color when disabled for contrast.
/// - `pressedOpacity`: Slight opacity reduction (0.8) when pressed.
/// - `pressedScale`: Slight shrinking effect (0.98) on press to provide tactile feedback.

public struct SocialButtonProperties: ButtonStyleDescriptor {
    public var font: Font = .system(size: 17)
    public var verticalPadding: CGFloat = 14
    public var horizontalPadding: CGFloat = 0
    public var expandToFill: Bool = true
    public var cornerRadius: CGFloat = 8
    public var backgroundColor: Color = .white
    public var processingBackgroundColor: Color = .white
    public var foregroundColor: Color = .black
    public var disabledBackgroundColor: Color = Color(#colorLiteral(red: 0.8205705881, green: 0.8341342211, blue: 0.8606416583, alpha: 1))
    public var disabledForegroundColor: Color = .white
    public var pressedOpacity: Double = 0.8
    public var pressedScale: CGFloat = 0.98

    public init() {}
}
