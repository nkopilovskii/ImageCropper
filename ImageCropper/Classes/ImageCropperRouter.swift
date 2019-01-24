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
  fileprivate var dismiss: ImageCropperDismiss?
  
  init(for view: ImageCropperViewController, with completionHandler: @escaping ImageCropperCompletion) {
    self.view = view
    self.completionHandler = completionHandler
  }

  
  init(for view: ImageCropperViewController, with completionHandler: @escaping ImageCropperCompletion, dismiss: @escaping ImageCropperDismiss) {
    self.view = view
    self.completionHandler = completionHandler
    self.dismiss = dismiss
  }
}

//MARK: - ImageCropperRouter

extension ImageCropperRouterImplementation: ImageCropperRouter {
  func finish(with croppedImage: UIImage) {
    self.completionHandler(croppedImage)
    if let dismiss = dismiss { dismiss() }
  }
  
  func cancel() {
    guard let dismiss = dismiss else {
      guard let navigationController = view?.navigationController else {
        view?.dismiss(animated: true, completion: nil)
        return
      }
      navigationController.popViewController(animated: true)
      return
    }
    
    dismiss()
  }
  
  
}
