//
//  Media.swift
//  LetsDummy
//
//  Created by Maraj Hossain on 8/3/25.
//

import UIKit

/// An enum to encapsulate a photo or video.
public enum Media: Equatable {
    case image(UIImage)
    case video(MediaDetails)
}

public struct MediaDetails: Equatable {
    public let url: URL
    public let size: String
    public let data: Data
}
