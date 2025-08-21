//
//  AdaptiveImage.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//


import SwiftUI

public struct AdaptiveImage: View {
    let name: String
    private let ratio: CGFloat?

    public init(_ name: String) {
        self.name = name
        if let uiImage = UIImage(named: name) {
            self.ratio = uiImage.size.height / uiImage.size.width
        } else {
            self.ratio = nil
        }
    }

    public var body: some View {
        Group {
            if let ratio = ratio {
                if ratio > 1 {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            } else {
                Color.gray
            }
        }
    }
}
