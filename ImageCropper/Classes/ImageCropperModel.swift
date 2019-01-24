//
//  Created by Nick Kopilovskii on 30.05.2018.
//  Copyright © 2018 Nick Kopilovskii. All rights reserved.
//

import UIKit

class ImageCropperModelImplementation  {

  fileprivate let configuration: ImageCropperConfiguration
  
  fileprivate var parentRect: CGRect?
  
  fileprivate var initialSize: CGSize?
  
  fileprivate var figureFrame: CGRect?
  fileprivate var panLastLocation: CGPoint?
  fileprivate var imageFrame = CGRect.zero
  fileprivate var gridSize:CGFloat?
  
  fileprivate var cornerRadius = CGFloat(0)
  
  
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
      
      let figureSize = configuration.figure.maskSize(with: newValue.size, ratio: configuration.customRatio)
      figureFrame = CGRect(x: (newValue.width - figureSize.width) / 2, y: (newValue.height - figureSize.height) / 2, width: figureSize.width, height: figureSize.height)
      cornerRadius =  min(figureSize.width, figureSize.height) / 2 * configuration.cornerRadius
      
      imageFrame = imageInitialFrame
    }
  }
  
  var imageInitialFrame: CGRect {
    let figureSize = figureFrame?.size ?? .zero
    var size = image.size.scale(to: figureSize)
    size = CGSize(width: size.width * 1.25, height: size.height * 1.25)
    return CGRect(x: (parentFrame.width - size.width) / 2, y: (parentFrame.height - size.height) / 2, width: size.width, height: size.height)
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
    guard let frame = figureFrame else { return UIBezierPath(rect: .zero).cgPath }
    return UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius != 0 ? cornerRadius : 1.0).cgPath
  }
  
  var borderColor: CGColor {
    return configuration.borderColor?.cgColor ?? UIColor.lightGray.cgColor
  }
  
  var grid: [CGPath] {
    guard configuration.showGrid else { return [CGPath]() }
    guard let frame = figureFrame else { return [CGPath]() }
    let step = configuration.figure == .customRect ? 0 : frame.width / CGFloat(configuration.figure.gridUnitDevider())
    let parentFrame = self.parentFrame
    
    var lines = [CGPath]()

    /* drawin horizontal grid lines up from figure origin */
    lines.append(contentsOf: NKGridBuilder.up.lines(from: frame.origin, in: parentFrame, with: step))
    /* drawin vertical grid lines down from figure origin */
    lines.append(contentsOf: NKGridBuilder.down.lines(from: frame.origin, in: parentFrame, with: step))
    /* drawin vertical grid lines left from figure origin */
    lines.append(contentsOf: NKGridBuilder.left.lines(from: frame.origin, in: parentFrame, with: step))
    /* drawin vertical grid lines right from figure origin */
    lines.append(contentsOf: NKGridBuilder.right.lines(from: frame.origin, in: parentFrame, with: step))

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
  
  var backTitle: String? {
    return configuration.backTitle
  }
  
  var backImage: UIImage? {
    return configuration.backImage
  }
  
  var backTintColor: UIColor? {
    return configuration.backTintColor
  }
  
  func draggingFrame(for point: CGPoint) -> CGRect {
    let previousLocation = panLastLocation ?? point
    let difference = CGPoint(x: point.x - previousLocation.x, y: point.y - previousLocation.y)
    
    guard let borders = figureFrame else { return imageFrame }
    
    let x = imageFrame.origin.x + difference.x
    let newX = x < borders.origin.x && x + imageFrame.width > borders.maxX ? x : imageFrame.origin.x
    
    let y = imageFrame.origin.y + difference.y
    let newY = y < borders.origin.y && y + imageFrame.height > borders.maxY ? y : imageFrame.origin.y
    
    imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: imageFrame.size)
    panLastLocation = point
    return imageFrame
  }
  
  func setStartedPinch() {
    initialSize = CGSize(width: imageFrame.width, height: imageFrame.height)
  }
  
  func scalingFrame(for scale: CGFloat) -> CGRect {
    let borders = figureFrame ?? .zero
    let pinchStartSize: CGSize
    if initialSize == nil {
      pinchStartSize = CGSize(width: imageFrame.width, height: imageFrame.height)
    } else {
      pinchStartSize = initialSize!
    }
    var newSize = CGSize(width: pinchStartSize.width * scale, height: pinchStartSize.height * scale)
    
    if newSize.width < borders.width || newSize.height < borders.height {
      newSize = image.size.scale(to: borders.size)
    }
    var newX = imageFrame.origin.x - (newSize.width - imageFrame.width) / 2
    var newY = imageFrame.origin.y - (newSize.height - imageFrame.height) / 2
    
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
    
    if newSize.width / image.size.width < 2 || newSize.height / image.size.height < 2  {
      imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: newSize)
    }
    
    return imageFrame
  }
  
  func transformatingFinished() {
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
    guard let borders = figureFrame else {
      return image
    }
    let point = CGPoint(x: borders.origin.x - imageFrame.origin.x, y: borders.origin.y - imageFrame.origin.y)
    let frame = CGRect(origin: point, size: borders.size)
    let x = frame.origin.x * image.size.width / imageFrame.width
    let y = frame.origin.y * image.size.height / imageFrame.height
    let width = frame.width * image.size.width / imageFrame.width
    let height = frame.height * image.size.height / imageFrame.height
    let croppedRect = CGRect(x: x, y: y, width: width, height: height)
    guard let imageRef = image.cgImage?.cropping(to: croppedRect) else {
      return image
    }
    
    let croppedImage = UIImage(cgImage: imageRef)
    return configuration.cornerRadius != 0 ? cutCorners(for: croppedImage) : croppedImage

  }
  
  func cutCorners(for originalImage: UIImage) -> UIImage {
    let imgRect = CGRect(origin: .zero, size: originalImage.size)
    let cornerRadius = min(imgRect.width, imgRect.height) / 2 * configuration.cornerRadius
    let path = UIBezierPath(roundedRect: imgRect, cornerRadius: cornerRadius)
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, false, 0)
    path.addClip()
    originalImage.draw(at: .zero)
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return croppedImage ?? originalImage
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
  fileprivate func maskSize(with parentSize:CGSize, ratio: CGSize?) -> CGSize {
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
    case .customRect:
      let customRatio = ratio ?? CGSize(width: 1, height: 1) //else { return ImageCropperConfiguration.ImageCropperFigureType.square.maskSize(with:parentSize) }
      if customRatio.width > customRatio.height {
        width = parentVertical ? parentSize.width * 0.8 : parentSize.width * 0.6
        height = width * customRatio.height / customRatio.width
      }
      else if customRatio.width < customRatio.height {
        height = parentSize.height * 0.7
        width = height * customRatio.width / customRatio.height
      }
      else {
        return ImageCropperConfiguration.ImageCropperFigureType.square.maskSize(with:parentSize, ratio: customRatio)
      }
//      fatalError()
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
    case .customRect:
      return 0
//      fatalError()
    }
  }
  
}


fileprivate enum NKGridBuilder {
  case up, down, left, right
  
  private func delta(with step: CGFloat) -> CGPoint {
    switch self {
    case .up: return CGPoint(x: 0, y: -step)
    case .down: return CGPoint(x: 0, y: step)
    case .left: return CGPoint(x: -step, y: 0)
    case .right: return CGPoint(x: step, y: 0)
    }
  }
  
  private func lineStart(for point: CGPoint) -> CGPoint {
    switch self {
    case .up, .down: return CGPoint(x: 0, y: point.y)
    case .left, .right: return CGPoint(x: point.x, y: 0)
    }
  }
  
  private func lineEnd(for point: CGPoint, in size: CGSize) -> CGPoint {
    switch self {
    case .up, .down: return CGPoint(x: size.width, y: point.y)
    case .left, .right: return CGPoint(x: point.x, y: size.height)
    }
  }
  
  func lines(from point: CGPoint, in bounds: CGRect, with step: CGFloat) -> [CGPath] {
    guard step > 0 else { return [] }
    var lines = [CGPath]()
    let deltaPoint = delta(with: step)
    var benchmark = self == .up || self == .left ? CGPoint(x: point.x + deltaPoint.x, y: point.y + deltaPoint.y) : point
    
    while bounds.contains(benchmark) {
      let linePath = UIBezierPath()
      linePath.move(to: lineStart(for: benchmark))
      linePath.addLine(to: lineEnd(for: benchmark, in: bounds.size))
      lines.append(linePath.cgPath)
      
      benchmark = CGPoint(x: benchmark.x + deltaPoint.x, y: benchmark.y + deltaPoint.y)
    }
    
    return lines
  }
}

extension CGSize {
  func scale(to size: CGSize) -> CGSize {
    var newWidth: CGFloat
    var newHeight: CGFloat
    
    if width > height {
      newHeight = size.height
      newWidth = newHeight * width / height
    } else if width < height {
      newWidth = size.width
      newHeight = newWidth * height / width
    } else {
      newHeight = max(size.width, size.height)
      newWidth = newHeight
    }
    
    if newHeight < size.height {
      newHeight = size.height
      newWidth = newHeight * width / height
    } else if newWidth < size.width {
      newWidth = size.width
      newHeight = newWidth * height / width
    }
    return CGSize(width: newWidth, height: newHeight) //??  .zero
  }
}
