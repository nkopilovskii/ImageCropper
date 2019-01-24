//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
// 
//  MainRouter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit
import ImageCropper

class MainRouterImplementation: NSObject {
  
  private weak var view: MainViewController?
  private var imagePicker: UIImagePickerController?
  
  init(for view: MainViewController) {
    self.view = view
  }
  
}

//MARK: - MainRouter

extension MainRouterImplementation: MainRouter {
  
  func openPhotoLibrary() {
    guard let vc = view else { return }
    
    imagePicker = UIImagePickerController()
    imagePicker?.modalPresentationStyle = .popover
    imagePicker?.popoverPresentationController?.sourceView = vc.view
    imagePicker?.delegate = vc
    imagePicker?.sourceType = .photoLibrary
    vc.present(imagePicker!, animated: true, completion: nil)
  }
  
  func closePhotoLibrary() {
    guard let picker = imagePicker else { return }
    picker.dismiss(animated: true)
  }
  
  func openCropper(with figure: ImageCropperConfiguration.ImageCropperFigureType, image: Data, cornerRadius: CGFloat?) {
    guard let img = UIImage(data: image) else { return }
    var config = ImageCropperConfiguration(with: img, and: figure, cornerRadius: cornerRadius)
    config.showGrid = true
    if figure == .customRect {
      config.customRatio = CGSize(width: 6, height: 5)
    }
    
    config.backTintColor = .black
    config.backTitle = ""
    
    var croppedImage = img
    let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
      guard let _img = _croppedImage else { return }
      croppedImage = _img
    }) {
      self.openPostProduction(with: croppedImage)
    }
    
    view?.navigationController?.pushViewController(cropper, animated: true)
  }
  
  func showAlertNoImage() {
    let alert = UIAlertController(title: "Error", message: "Please, select image!", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .destructive) { action in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    view?.present(alert, animated: true, completion: nil)
    return
    
  }
  
  func openPostProduction(with image:UIImage) {
    guard let result = UIStoryboard(name: "PostProduction", bundle: nil).instantiateInitialViewController() as? PostProductionViewController else { return}
    
    result.image = image
    view?.navigationController?.pushViewController(result, animated: true)
  }
  
}

