//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
// 
//  MainPresenter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import Foundation
import ImageCropper

protocol MainView: class {
  var cornerRadius: CGFloat? { get }
  func isBtnsFiguresEnable(_ enable:Bool)
}

protocol MainPresenter {

  func viewDidLoad()
  func getImage()
  func didSelect(_ image: Data)
  func cropFigure(_ figureID: Int)
  
}

protocol MainRouter {
  func openPhotoLibrary()
  func closePhotoLibrary()
  func openCropper(with figure: ImageCropperConfiguration.ImageCropperFigureType, image: Data, cornerRadius: CGFloat?)
  func showAlertNoImage()
}

class MainPresenterImplementation {

  private weak var view: MainView?
  
  private let router: MainRouter
  
  private var imageData: Data?
  //MARK: -
  
  init(for view: MainView, with router: MainRouter) {

    self.view = view
    self.router = router

  }
  
}

//MARK: - MainPresenter

extension MainPresenterImplementation: MainPresenter {

  func viewDidLoad() {
    view?.isBtnsFiguresEnable(false)
  }
  
  func getImage() {
    router.openPhotoLibrary()
  }

  func didSelect(_ image: Data) {
    imageData = image
    router.closePhotoLibrary()
    view?.isBtnsFiguresEnable(true)
  }
  
  func cropFigure(_ figureID: Int) {
    
    guard let figure = ImageCropperConfiguration.ImageCropperFigureType(rawValue: figureID) else { return }
    
    guard let img = imageData else {
      router.showAlertNoImage()
      return
    }
    router.openCropper(with: figure, image: img, cornerRadius: view?.cornerRadius)
  }
}
