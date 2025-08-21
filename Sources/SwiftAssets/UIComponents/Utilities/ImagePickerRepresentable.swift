//
//  ImagePickerRepresentable.swift
//  Core
//
//  Created by Promal on 8/8/25.
//

import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

/// A `UIViewControllerRepresentable` for `UIImagePickerController` (Camera).
public struct ImagePickerRepresentable: UIViewControllerRepresentable {
    @Binding public var pickedMedia: Media?
    @Environment(\.dismiss) var dismiss
    public var sourceType: UIImagePickerController.SourceType
    public var mediaTypes: [String]

    public init(
        pickedMedia: Binding<Media?>,
        sourceType: UIImagePickerController.SourceType,
        mediaTypes: [String]
    ) {
        self._pickedMedia = pickedMedia
        self.sourceType = sourceType
        self.mediaTypes = mediaTypes
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = mediaTypes
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerRepresentable

        init(parent: ImagePickerRepresentable) {
            self.parent = parent
        }

        public func imagePickerController(
            _: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            parent.dismiss()

            if let mediaType = info[.mediaType] as? String {
                if mediaType == UTType.movie.identifier, let url = info[.mediaURL] as? URL {
                    do {
                        let fileData = try Data(contentsOf: url)

                        // Get file size for display
                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
                        let sizeString: String
                        if let fileSize = fileAttributes[.size] as? Int64 {
                            let formatter = ByteCountFormatter()
                            formatter.allowedUnits = [.useMB, .useGB]
                            formatter.countStyle = .file
                            sizeString = formatter.string(fromByteCount: fileSize)
                        } else {
                            sizeString = "Unknown size"
                        }
                        let mediaDetails = MediaDetails(url: url, size: sizeString, data: fileData)
                        parent.pickedMedia = .video(mediaDetails)
                    } catch {
                        print("Failed to read file attributes: \(error)")
                    }
                } else if mediaType == UTType.image.identifier, let image = info[.originalImage] as? UIImage {
                    parent.pickedMedia = .image(image)
                }
            }
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - UIViewControllerRepresentable Wrappers

/// A `UIViewControllerRepresentable` for `PHPickerViewController` (Photo Library).
public struct PHImagePickerRepresentable: UIViewControllerRepresentable {
    @Binding public var pickedMedia: Media?
    @Environment(\.dismiss) var dismiss
    public var filter: PHPickerFilter

    public init(pickedMedia: Binding<Media?>, filter: PHPickerFilter) {
        self._pickedMedia = pickedMedia
        self.filter = filter
    }

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = filter
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_: PHPickerViewController, context _: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public final class Coordinator: PHPickerViewControllerDelegate {
        var parent: PHImagePickerRepresentable

        init(parent: PHImagePickerRepresentable) {
            self.parent = parent
        }

        public func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()

            guard let result = results.first else {
                return
            }

            let itemProvider = result.itemProvider

            if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                // Handle video - Load data directly to avoid temp file issues
                itemProvider.loadDataRepresentation(
                    forTypeIdentifier: UTType.movie.identifier
                ) { [weak self] data, error in
                    guard let self = self else { return }

                    DispatchQueue.main.async {
                        if let error = error {
                            print("❌ Error loading video data: \(error.localizedDescription)")
                            return
                        }

                        guard let videoData = data else {
                            print("❌ No video data provided")
                            return
                        }

                        // Create a permanent file from the data
                        do {
                            let documentsPath = FileManager.default.urls(
                                for: .documentDirectory,
                                in: .userDomainMask
                            ).first!
                            let fileName = "video_\(UUID().uuidString).mov"
                            let permanentURL = documentsPath.appendingPathComponent(fileName)

                            // Write data to permanent location
                            try videoData.write(to: permanentURL)
                            print("✅ Created permanent video file: \(permanentURL)")

                            // Get file size from data
                            let fileSize = Int64(videoData.count)
                            let formatter = ByteCountFormatter()
                            formatter.allowedUnits = [.useMB, .useGB]
                            formatter.countStyle = .file
                            let sizeString = formatter.string(fromByteCount: fileSize)

                            print("✅ Video file size: \(sizeString)")
                            let mediaDetails = MediaDetails(url: permanentURL, size: sizeString, data: videoData)
                            self.parent.pickedMedia = .video(mediaDetails)

                        } catch {
                            print("❌ Error creating permanent video file: \(error.localizedDescription)")
                        }
                    }
                }
            } else if itemProvider.canLoadObject(ofClass: UIImage.self) {
                // Handle image
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.pickedMedia = .image(image)
                        }
                    } else if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
