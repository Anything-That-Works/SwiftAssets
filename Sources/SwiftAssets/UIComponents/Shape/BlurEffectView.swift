//
//  BlurEffectView.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//


import SwiftUI

/// A UIViewRepresentable to create and manage a UIVisualEffectView
struct BlurEffectView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
