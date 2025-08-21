//
//  GradientText.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//


import SwiftUI

public struct GradientText: View {
    public let text: String
    public var font: Font
    public var colors: [Color]
    public var alignment: TextAlignment

    public init(
        _ text: String,
        font: Font = .system(size: 28, weight: .semibold),
        alignment: TextAlignment = .center,
        colors: [Color] = [
            Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),
            Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        ]
    ) {
        self.text = text
        self.font = font
        self.alignment = alignment
        self.colors = colors
    }

    public var body: some View {
        Text(text)
            .font(font)
            .multilineTextAlignment(.center)
            .overlay(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .mask(
                    Text(text)
                        .font(font)
                        .multilineTextAlignment(.center)
                )
            )
    }
}

struct GradientText_Previews: PreviewProvider {
    static var previews: some View {
        GradientText("Welcome")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
