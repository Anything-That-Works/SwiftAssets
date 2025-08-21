//
//  CustomSlider.swift
//  SwiftAssets
//
//  Created by Promal on 21/8/25.
//


import SwiftUI

public struct CustomSlider<Value, Track, Fill, Thumb>: View
where Value: BinaryFloatingPoint, Value.Stride: BinaryFloatingPoint, Track: View, Fill: View, Thumb: View {
    @Binding var value: Value
    let bounds: ClosedRange<Value>
    let step: Value
    let minimumValueLabel: Text?
    let maximumValueLabel: Text?
    let onEditingChanged: ((Bool) -> Void)?
    let track: () -> Track
    let fill: (() -> Fill)?
    let thumb: () -> Thumb
    let thumbSize: CGSize

    @State private var dragOffset: CGFloat = 0
    @State private var trackSize: CGSize = .zero
    @State private var dragStartPosition: CGFloat = 0
    @State private var hasDragStarted: Bool = false
    @State private var isDragging: Bool = false
    @State private var dragStartOffset: CGFloat = 0
    
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0.001,
        minimumValueLabel: Text? = nil,
        maximumValueLabel: Text? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        track: @escaping () -> Track,
        fill: (() -> Fill)?,
        thumb: @escaping () -> Thumb,
        thumbSize: CGSize
    ) {
        _value = value
        self.bounds = bounds
        self.step = step
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onEditingChanged = onEditingChanged
        self.track = track
        self.fill = fill
        self.thumb = thumb
        self.thumbSize = thumbSize
    }

    // Current value as percentage (0 to 1)
    private var percentage: Value {
        guard bounds.upperBound != bounds.lowerBound else { return 0 }
        return (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
    }

    // Thumb position based on current value
    private var thumbPosition: CGFloat {
        guard trackSize.width > thumbSize.width else { return 0 }
        let availableWidth = trackSize.width - thumbSize.width
        return availableWidth * CGFloat(percentage)
    }

    // Actual thumb offset (includes drag offset when dragging)
    private var actualThumbOffset: CGFloat {
        isDragging ? dragOffset : thumbPosition
    }

    // Fill width based on thumb position
    private var fillWidth: CGFloat {
        actualThumbOffset + thumbSize.width / 2
    }

    public var body: some View {
        HStack {
            minimumValueLabel

            ZStack(alignment: .leading) {
                // Track
                track()
                    .frame(maxWidth: .infinity)
                    .measureSize { size in
                        trackSize = size
                    }

                // Fill
                fill?()
                    .frame(width: max(0, fillWidth), height: trackSize.height)
                    .clipped()

                // Thumb
                thumb()
                    .frame(width: thumbSize.width, height: thumbSize.height)
                    .offset(x: actualThumbOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                handleDragChanged(gesture)
                            }
                            .onEnded { gesture in
                                handleDragEnded(gesture)
                            }
                    )
            }
            .frame(height: max(trackSize.height, thumbSize.height))

            maximumValueLabel
        }
    }

    private func handleDragChanged(_ gesture: DragGesture.Value) {
        if !isDragging {
            isDragging = true
            dragStartOffset = thumbPosition
            onEditingChanged?(true)
        }

        let availableWidth = trackSize.width - thumbSize.width
        guard availableWidth > 0 else { return }

        // Calculate new position based on drag translation from start position
        let newPosition = dragStartOffset + gesture.translation.width
        dragOffset = min(availableWidth, max(0, newPosition))

        // Convert position to value
        let rawPercentage = dragOffset / availableWidth
        let rawValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Value(rawPercentage)

        // Apply stepping
        let steppedValue = round(rawValue / step) * step
        let clampedValue = min(bounds.upperBound, max(bounds.lowerBound, steppedValue))

        // Update value without triggering position recalculation
        if clampedValue != value {
            value = clampedValue
        }
    }

    private func handleDragEnded(_ gesture: DragGesture.Value) {
        withAnimation {
            isDragging = false
            onEditingChanged?(false)

            // Reset drag offset - thumb will return to value-based position
            dragOffset = 0
        }
    }
}

// MARK: - Helper Extensions
struct MeasureSize: ViewModifier {
    let onChange: (CGSize) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func measureSize(onChange: @escaping (CGSize) -> Void) -> some View {
        modifier(MeasureSize(onChange: onChange))
    }
}
