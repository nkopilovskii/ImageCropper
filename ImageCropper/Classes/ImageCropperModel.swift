//
//  Created by Nick Kopilovskii on 30.05.2018.
//  Copyright © 2018 Nick Kopilovskii. All rights reserved.
//

import UIKit

class ImageCropperModelImplementation  {

  fileprivate let configuration: ImageCropperConfiguration
  
  fileprivate var parentRect: CGRect?
  
  fileprivate var figureFrame: CGRect?
  fileprivate var panLastLocation: CGPoint?
  fileprivate var pinchLastScale: CGFloat?
  fileprivate var imageFrame = CGRect.zero
  fileprivate var imageScalingLastFrame: CGRect?
  fileprivate var gridSize:CGFloat?
  
  init(with configuration: ImageCropperConfiguration) {
    self.configuration = configuration
  }
}


extension ImageCropperModelImplementation: ImageCropperModel {
  
  var image: UIImage {
    return configuration.image
  }
  
  var parentFrame: CGRect {
    get {
      return parentRect ?? .zero
    }
    set {
      parentRect = newValue
      
      let figureSize = configuration.figure.maskSize(with: newValue.size)
      figureFrame = CGRect(x: (newValue.width - figureSize.width) / 2, y: (newValue.height - figureSize.height) / 2, width: figureSize.width, height: figureSize.height)
      
      imageFrame = imageInitialFrame
    }
  }
  
  var imageInitialFrame: CGRect {
    var width: CGFloat, height: CGFloat
    
    if image.size.width > image.size.height {
      width = parentFrame.width * 0.95
      height = width * image.size.height / image.size.width
      
      if let borderHeight = figureFrame?.height, (height - borderHeight) < 25 {
        height = borderHeight * 1.25
        width = height * image.size.width / image.size.height
      }
    }
    else if image.size.width < image.size.height {
      height = parentFrame.height * 0.8
      width = height * image.size.width / image.size.height
      
      if let borderWidth = figureFrame?.width, (width - borderWidth) < 25 {
        width = borderWidth * 1.25
        height = width * image.size.height / image.size.width
      }
    }
    
    else if image.size.width == image.size.height {
      width = parentFrame.width * 0.95
      height = width
    } else {
      return .zero
    }
    
    return CGRect(x: (parentFrame.width - width) / 2, y: (parentFrame.height - height) / 2, width: width, height: height)
  }
  
  var mask: CGPath {
    guard figureFrame != nil else {
      return UIBezierPath(rect: .zero).cgPath
    }
    let hole = UIBezierPath(cgPath: border)
    let path = UIBezierPath(roundedRect: parentFrame, cornerRadius: 0)
    path.append(hole)
    return path.cgPath
  }
  
  var fillColor: UIColor {
    if #available(iOS 10.0, *) {
      return configuration.maskFillColor ?? UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
    } else {
      return configuration.maskFillColor ?? UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
  }
  
  var border: CGPath {
    guard let frame = figureFrame else {
      return UIBezierPath(rect: .zero).cgPath
    }
    return UIBezierPath(roundedRect: frame, cornerRadius: configuration.figure == .circle ? frame.width / 2 : 1.0).cgPath
  }
  
  var borderColor: CGColor {
    return configuration.borderColor?.cgColor ?? UIColor.lightGray.cgColor
  }
  
  var grid: [CGPath] {
    guard configuration.showGrid else { return [CGPath]() }
    guard let frame = figureFrame else { return [CGPath]() }
    let size = frame.width / CGFloat(configuration.figure.gridUnitDevider())
    let parentFrame = self.parentFrame
    
    var lines = [CGPath]()

    /*
     drawin vertical grid lines left from figure origin
     */
    var benchmark = frame.origin
    while benchmark.x > 0 {
      benchmark = CGPoint(x: benchmark.x - size, y: benchmark.y)
    
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: benchmark.x, y: 0))
      linePath.addLine(to: CGPoint(x: benchmark.x, y: parentFrame.height))
      
      lines.append(linePath.cgPath)
    }
    
    /*
     drawin vertical grid lines right from figure origin
     */
    benchmark = CGPoint(x: frame.origin.x - size, y: benchmark.y)
    while benchmark.x < parentFrame.width {
      benchmark = CGPoint(x: benchmark.x + size, y: benchmark.y)
      
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: benchmark.x, y: 0))
      linePath.addLine(to: CGPoint(x: benchmark.x, y: parentFrame.height))
      
      lines.append(linePath.cgPath)
    }
    
    /*
     drawin horizontal grid lines up from figure origin
     */
    benchmark = frame.origin
    while benchmark.y > 0 {
      benchmark = CGPoint(x: benchmark.x, y: benchmark.y - size)
      
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: 0, y: benchmark.y))
      linePath.addLine(to: CGPoint(x: parentFrame.width, y: benchmark.y))
      
      lines.append(linePath.cgPath)
    }
    
    /*
     drawin vertical grid lines down from figure origin
     */
    benchmark = CGPoint(x: frame.origin.x, y: benchmark.y - size)
    while benchmark.y < parentFrame.height {
      benchmark = CGPoint(x: benchmark.x, y: benchmark.y + size)
      
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: 0, y: benchmark.y))
      linePath.addLine(to: CGPoint(x: parentFrame.width, y: benchmark.y))
      
      lines.append(linePath.cgPath)
    }

    return lines
  }
  
  var gridColor: CGColor {
    if #available(iOS 10.0, *) {
      return configuration.gridColor?.cgColor ?? UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
    } else {
      return configuration.gridColor?.cgColor ?? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
    }
  }
  
  var doneTitle: String? {
    return configuration.doneTitle
  }
  
  var cancelTitle: String? {
    return configuration.cancelTitle
  }
  
  func draggingFrame(for point: CGPoint) -> CGRect {
    let previousLocation = panLastLocation ?? point
    let difference = CGPoint(x: point.x - previousLocation.x, y: point.y - previousLocation.y)
    
    guard let borders = figureFrame else {
      return imageFrame
    }
    
    let x = imageFrame.origin.x + difference.x
    let newX = x < borders.origin.x && x + imageFrame.width > borders.maxX ? x : imageFrame.origin.x
    
    let y = imageFrame.origin.y + difference.y
    let newY = y < borders.origin.y && y + imageFrame.height > borders.maxY ? y : imageFrame.origin.y
    
    imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: imageFrame.size)
    panLastLocation = imageFrame.contains(borders) ? point : panLastLocation

    return imageFrame
  }
  
  func scalingFrame(for scale: CGFloat) -> CGRect {
    let lastFrame = imageScalingLastFrame ?? imageFrame
    let newSize = CGSize(width: lastFrame.width * scale, height: lastFrame.height * scale)
  
    guard let borders = figureFrame, newSize.width >= borders.width, newSize.height >= borders.height   else {
      return imageFrame
    }
    var newX = lastFrame.origin.x - (newSize.width - lastFrame.width) / 2
    var newY = lastFrame.origin.y - (newSize.height - lastFrame.height) / 2
   
    if newX + newSize.width <= borders.maxX {
      newX = borders.maxX - newSize.width
    }
    else if newX >= borders.origin.x {
      newX = borders.origin.x
    }
    
    if newY + newSize.height <= borders.maxY {
      newY = borders.maxY - newSize.height
    }
    else if newY >= borders.origin.y {
      newY = borders.origin.y
    }

    imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: newSize)

    return imageFrame
  }
  
  func transformatingFinished() {
    imageScalingLastFrame = nil
    panLastLocation = nil
    
  }
  
  func centerFrame() -> CGRect {
    if imageInitialFrame.center != imageFrame.center {
      imageFrame.center = imageInitialFrame.center
    }
    else {
      imageFrame = imageInitialFrame
    }
    
    return imageFrame
  }
  
  func crop() -> UIImage {
    guard let bounds = parentRect, let borders = figureFrame else {
      return image
    }
    
    let frame = CGRect(origin: CGPoint(x: borders.origin.x - imageFrame.origin.x, y: borders.origin.y - imageFrame.origin.y), size: borders.size)
    let x = frame.origin.x * image.size.width / imageFrame.width
    let y = frame.origin.y * image.size.height / imageFrame.height
    let width = frame.width * image.size.width / imageFrame.width
    let height = frame.height * image.size.height / imageFrame.height
    let croppedRect = CGRect(x: x, y: y, width: width, height: height)
    
    guard let imageRef = image.cgImage?.cropping(to: croppedRect) else {
      return image
    }
    
    UIGraphicsBeginImageContextWithOptions(croppedRect.size, false, 1)
    
    let cornerRadius = configuration.figure == .circle ? width / 2 : 0
    let roundedRect =  CGRect(origin: .zero, size: croppedRect.size)
    UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius * image.size.width / bounds.width).addClip()
    UIImage(cgImage: imageRef, scale: 1, orientation: image.imageOrientation).draw(in: roundedRect)
    
    guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return image
    }
    
    UIGraphicsEndImageContext()
    
    return croppedImage
  }

}

extension CGRect {
  var center: CGPoint {
    set {
      origin.x = newValue.x - width / 2
      origin.y = newValue.y - height / 2
    }
    
    get {
      return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
    }
  }
}

extension ImageCropperConfiguration.ImageCropperFigureType {
  fileprivate func maskSize(with parentSize:CGSize) -> CGSize {
    let parentVertical = parentSize.width < parentSize.height
    var width: CGFloat, height: CGFloat
    switch self {
    case .circle, .square:
      width = parentVertical ? parentSize.width * 0.75 : parentSize.height * 0.65
      height = width
    case .rect2x1:
      width = parentVertical ? parentSize.width * 0.6 : parentSize.width * 0.7
      height = width / 2
    case .rect1x2:
      height = parentSize.height * 0.6
      width = height / 2
    case .rect4x3:
      width = parentVertical ? parentSize.width * 0.6 : parentSize.height * 0.8
      height = width * 3 / 4
    case .rect3x4:
      height = parentSize.height * 0.6
      width = height * 3 / 4
    case .rect16x9:
      width = parentVertical ? parentSize.width * 0.8 : parentSize.width * 0.6
      height = width * 9 / 16
    case .rect9x16:
      height = parentSize.height * 0.7
      width = height * 9 / 16
    }
    
    return CGSize(width: width, height: height)
  }
  
  fileprivate func gridUnitDevider() -> Int {
    switch self {
    case .circle, .square, .rect2x1:
      return 2
    case .rect1x2:
      return 1
    case .rect4x3:
      return 4
    case .rect3x4:
      return 3
    case .rect16x9:
      return 16
    case .rect9x16:
      return 9
    }
  }
}
