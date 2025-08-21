//
//  GlossyShapeStyle.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//


import SwiftUI

struct GlossyShapeStyle<S: Shape>: View {
    let shape: S
    let strokeColor: Color
    let lineWidth: CGFloat
    let blurRadius: CGFloat
    let shadowColor: (light: Color, dark: Color)
    let shadowRadius: CGFloat
    let shadowX: CGFloat
    let shadowY: CGFloat

    var body: some View {
        shape
            .stroke(strokeColor, lineWidth: lineWidth)
            .background(
                BlurEffectView()
                    .blur(radius: blurRadius)
                    .clipShape(shape)
            )
            .shadow(
                color: shadowColor.dark.opacity(0.2),
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
            .shadow(
                color: shadowColor.light.opacity(0.2),
                radius: shadowRadius,
                x: -shadowX,
                y: -shadowY
            )
    }
}

public extension Shape {
    func glossyStyle(
        strokeColor: Color = .white.opacity(0.2),
        lineWidth: CGFloat = 1,
        blurRadius: CGFloat = 3,
        shadowColor: (light: Color, dark: Color) = (
            .white, .black
        ),
        shadowRadius: CGFloat = 10,
        shadowX: CGFloat = 5,
        shadowY: CGFloat = 5
    ) -> some View {
        GlossyShapeStyle(
            shape: self,
            strokeColor: strokeColor,
            lineWidth: lineWidth,
            blurRadius: blurRadius,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowX: shadowX,
            shadowY: shadowY
        )
    }
}
