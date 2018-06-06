// 
//  ImageCropperRouter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

class ImageCropperRouterImplementation {

  fileprivate weak var view: ImageCropperViewController?
  fileprivate var completionHandler: ImageCropperCompletion
  
  init(for view: ImageCropperViewController, with completionHandler: @escaping ImageCropperCompletion) {
    self.view = view
    self.completionHandler = completionHandler
  }

}

//MARK: - ImageCropperRouter

extension ImageCropperRouterImplementation: ImageCropperRouter {
  func finish(with croppedImage: UIImage) {
    completionHandler(croppedImage)
  }
  
  func cancel() {
    guard let navigationController = view?.navigationController else {
      view?.dismiss(animated: true, completion: nil)
      return
    }
    
    navigationController.popViewController(animated: true)
  }
  
  
}
