//
//  PrimaryButtonProperties.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI

/// A concrete implementation of `ButtonStyleDescriptor` defining the default appearance and behavior
/// of a primary action button used across the application.
///
/// ### Properties:
/// - `font`: Uses a custom regular font at size 17.
/// - `verticalPadding`: 14 points of vertical padding inside the button.
/// - `horizontalPadding`: 20 points of horizontal padding inside the button.
/// - `expandToFill`: Button expands to fill available horizontal space.
/// - `cornerRadius`: 8-point rounded corners for a smooth appearance.
/// - `backgroundColor`: Uses `ColorSet.primary` as the main background color.
/// - `processingBackgroundColor`: A color shown during ongoing actions (e.g., loading).
/// - `foregroundColor`: White text color in active state.
/// - `disabledBackgroundColor`: A light gray background when the button is disabled.
/// - `disabledForegroundColor`: White foreground color when disabled.
/// - `pressedOpacity`: Slight opacity reduction (0.8) when pressed.
/// - `pressedScale`: Slight shrinking effect (0.98) on press for tactile feedback.

public struct PrimaryButtonProperties: ButtonStyleDescriptor {
    public init() {}
    
    public var font: Font = .system(size: 17)
    public var verticalPadding: CGFloat = 14
    public var horizontalPadding: CGFloat = 20
    public var expandToFill: Bool = true
    public var cornerRadius: CGFloat = 8
    public var backgroundColor: Color = Color.blue
    public var processingBackgroundColor: Color = Color.blue.opacity(0.5)
    public var foregroundColor: Color = .white
    public var disabledBackgroundColor: Color = Color(#colorLiteral(red: 0.8205705881, green: 0.8341342211, blue: 0.8606416583, alpha: 1))
    public var disabledForegroundColor: Color = .white
    public var pressedOpacity: Double = 0.8
    public var pressedScale: CGFloat = 0.98
}
