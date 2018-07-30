//
//  Created by Nick Kopilovskii on 28.05.2018.
//  Copyright © 2018 Nick Kopilovskii. All rights reserved.
//

import UIKit

public typealias ImageCropperCompletion = (UIImage?) -> Void
public typealias ImageCropperDismiss = () -> Void


public struct ImageCropperConfiguration {
  
  public enum ImageCropperFigureType: Int {
    case circle 
    case square
    case rect2x1
    case rect1x2
    case rect4x3
    case rect3x4
    case rect16x9
    case rect9x16
    case customRect
  }
  
  var image: UIImage
  var figure: ImageCropperFigureType
  
  public var customRatio: CGSize?
  
  public var maskFillColor: UIColor?
  public var borderColor: UIColor?
  
  public var showGrid = false
  public var gridColor: UIColor?
  public var doneTitle: String?
  public var cancelTitle: String?
  
  public var backTitle: String?
  public var backImage: UIImage?
  public var backTintColor: UIColor?
  
  
  public init(with image: UIImage, and figure: ImageCropperFigureType) {
    self.image = image.normalizeOrientation()
    self.figure = figure
  }
  
}


