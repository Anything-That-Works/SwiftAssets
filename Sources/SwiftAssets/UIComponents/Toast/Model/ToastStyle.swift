//
//  ToastStyle.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import Foundation
import SwiftUI

public enum ToastStyle: String {
    case error = "Error"
    case warning = "Warning"
    case success = "Success"
    case info = "Info"
}

public extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }

    var icon: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .success: return "checkmark.circle"
        case .error: return "xmark.circle"
        }
    }
}
