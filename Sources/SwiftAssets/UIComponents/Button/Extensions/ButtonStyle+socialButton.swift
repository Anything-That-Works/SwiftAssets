//
//  ButtonStyle+socialButton.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static func socialButton(
        properties: some ButtonStyleDescriptor = SocialButtonProperties(),
        isProcessing: Bool = false
    ) -> PrimaryButtonStyle {
        .init(properties: properties, isProcessing: isProcessing)
    }
}
