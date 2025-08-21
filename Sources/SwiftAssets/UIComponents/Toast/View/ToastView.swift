//
//  ToastView.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundColor(style.themeColor)
                Text(style.rawValue)
                    .font(.system(size: 17).bold())
                    .foregroundColor(style.themeColor)
                Spacer()
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.themeColor)
                }
            }
            
            Text(message)
                .font(.system(size: 15))
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(colorScheme == .light ? Color.white : Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style.themeColor, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

struct PreviewToast: View {
    @State var toast: Toast? = Toast(style: .success, message: "Something went Wrong", duration: 60.0)
    var body: some View {
        Color.red.ignoresSafeArea()
            .toastView(toast: $toast)
    }
}

#Preview {
    PreviewToast()
}
