//
//  Created by Nick Kopilovskii on 28.05.2018.
//  Copyright © 2018 Nick Kopilovskii. All rights reserved.
//

import UIKit

public typealias ImageCropperCompletion = (UIImage?) -> Void


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
  }
  
  var image: UIImage
  var figure: ImageCropperFigureType
  
  
  public var maskFillColor: UIColor?
  public var borderColor: UIColor?
  
  public var showGrid = false
  public var gridColor: UIColor?
  public var doneTitle: String?
  public var cancelTitle: String?
  
  
  public init(with image: UIImage, and figure: ImageCropperFigureType) {
    self.image = image
    self.figure = figure
  }
  
}


