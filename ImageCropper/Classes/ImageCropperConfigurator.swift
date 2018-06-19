
//
//  ImageCropperConfigurator.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import Foundation

protocol ImageCropperConfigurator {
  static func configure(for view: ImageCropperViewController, with configuration:ImageCropperConfiguration,  completionHandler: @escaping ImageCropperCompletion)
  
  static func configure(for view: ImageCropperViewController, with configuration:ImageCropperConfiguration,  completionHandler: @escaping ImageCropperCompletion, dismiss: @escaping ImageCropperDismiss)
}

class ImageCropperConfiguratorImplementation { }

extension ImageCropperConfiguratorImplementation: ImageCropperConfigurator {

  static func configure(for view: ImageCropperViewController, with configuration:ImageCropperConfiguration,  completionHandler: @escaping ImageCropperCompletion) {
    
    let router = ImageCropperRouterImplementation(for: view, with: completionHandler)
    
    let model = ImageCropperModelImplementation(with: configuration)
    
    let presenter = ImageCropperPresenterImplementation(for: view, with: router, and: model)
    view.presenter = presenter
  }
  
  static func configure(for view: ImageCropperViewController, with configuration:ImageCropperConfiguration,  completionHandler: @escaping ImageCropperCompletion, dismiss: @escaping ImageCropperDismiss) {
    
    let router = ImageCropperRouterImplementation(for: view, with: completionHandler, dismiss: dismiss)
    
    let model = ImageCropperModelImplementation(with: configuration)
    
    let presenter = ImageCropperPresenterImplementation(for: view, with: router, and: model)
    view.presenter = presenter
    
  }
  
}







