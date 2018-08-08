//
//  UIImage+NormalizeOrientation.swift
//  ImageCropper
//
//  Created by Nick Kopilovskii on 26.07.2018.
//

import UIKit

public extension UIImage {
  func normalizeOrientation() -> UIImage {
    guard imageOrientation != .up else { return self }
    UIGraphicsBeginImageContext(size)
    draw(in: CGRect(origin: .zero, size: size))
    let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return normalizedImage ?? self
  }
}
