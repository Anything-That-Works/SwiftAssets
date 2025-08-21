//
//  Toast.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import Foundation
import SwiftUI

public struct Toast: Equatable {
    public var style: ToastStyle
    public var message: String
    public var duration: Double = 3
    public var width: Double = .infinity

    public init(style: ToastStyle, message: String, duration: Double = 2, width: Double = .infinity) {
        self.style = style
        self.message = message
        self.duration = duration
        self.width = width
    }
}
