# UIAssets

A Swift package for reusable SwiftUI components, providing a collection of UI assets to build modern and consistent user interfaces.

## Components

This package includes a variety of UI components, including:

*   **Buttons:**
    *   Primary Button
    *   Social Media Buttons
*   **Sliders:**
    *   Customizable sliders
*   **Text:**
    *   Gradient Text
*   **Text Fields:**
    *   Standard Input Fields
    *   Multiline Text Input Views
*   **Toasts:**
    *   Customizable toast notifications
*   **Utilities:**
    *   Image Picker

## Usage

To use a component from this package, simply import `UIAssets` and then you can use the components in your SwiftUI views.

```swift
import SwiftUI
import UIAssets

struct ContentView: View {
    var body: some View {
        VStack {
            GradientText(text: "Hello, World!")
        }
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.
