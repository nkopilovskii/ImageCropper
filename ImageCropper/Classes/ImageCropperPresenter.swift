// 
//  ImageCropperPresenter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit


protocol ImageCropperView: class {
  
  func set(_ image: UIImage)
  func setImageFrame(_ frame: CGRect)
  func transformImage(with frame: CGRect)
  func clearMask()
  func drawMask(by path: CGPath, with fillColor: UIColor)
  func clearBorderAndGrid()
  func drawBorber(by path: CGPath, with strokeColor: CGColor)
  func drawGrid(with lines: [CGPath], with strokeColor: CGColor)
  
  func setDone(_ title: String?)
  func setCancel(_ title: String?)
  func showBottomButtons(_ show: Bool)
  
  func setBackButton(title: String?, image: UIImage?, tintColor: UIColor?)
  
  func activityIndicator(_ show: Bool)
}

protocol ImageCropperPresenter {
  
  func viewDidLoad()
  func viewDidLayoutSubviews(in frame: CGRect)
  func userInteraction(_ takesPlace: Bool)
  func didDrag(to location: CGPoint)
  func didPinchStarted()
  func didScale(with scale: CGFloat)
  
  func centerImage()
  
  func crop()
  func cancel()
}

protocol ImageCropperRouter {
  func finish(with croppedImage:UIImage)
  func cancel()
}

protocol ImageCropperModel {
  var image: UIImage { get }
  var parentFrame: CGRect { set get }
  var imageInitialFrame: CGRect { get }
  
  var mask: CGPath { get }
  var fillColor: UIColor { get }
  
  var border: CGPath { get }
  var borderColor: CGColor { get }
  
  var grid: [CGPath] { get }
  var gridColor: CGColor { get }
  
  var doneTitle: String? { get }
  var cancelTitle: String? { get }
  
  var backTitle: String? { get }
  var backImage: UIImage? { get }
  var backTintColor: UIColor? { get }
  
  func draggingFrame(for point: CGPoint) -> CGRect
  func setStartedPinch()
  func scalingFrame(for scale: CGFloat) -> CGRect
  func transformatingFinished()
  func centerFrame() -> CGRect
  
  func crop() -> UIImage
  
}

class ImageCropperPresenterImplementation {

  fileprivate weak var view: ImageCropperView?
  
  fileprivate let router: ImageCropperRouter
  
  fileprivate var model: ImageCropperModel
  
  //MARK: -
  
  init(for view: ImageCropperView, with router: ImageCropperRouter, and model: ImageCropperModel) {
    self.view = view
    self.router = router
    self.model = model
  }

}

//MARK: - ImageCropperPresenter

extension ImageCropperPresenterImplementation: ImageCropperPresenter {

  func viewDidLoad() {
    view?.set(model.image)
  }
  
  func viewDidLayoutSubviews(in frame: CGRect) {
    view?.clearMask()
    view?.clearBorderAndGrid()
    
    model.parentFrame = frame
    
    view?.setImageFrame(model.imageInitialFrame)
    view?.drawMask(by: model.mask, with: model.fillColor)
    view?.drawBorber(by: model.border, with: model.borderColor)
    view?.drawGrid(with: model.grid, with: model.gridColor)
    view?.setDone(model.doneTitle)
    view?.setCancel(model.cancelTitle)
    
    view?.setBackButton(title: model.backTitle, image: model.backImage, tintColor: model.backTintColor)
  }
  
  func userInteraction(_ takesPlace: Bool) {
    view?.showBottomButtons(!takesPlace)
    model.transformatingFinished()
  }
  
  func didDrag(to location: CGPoint) {
    view?.setImageFrame(model.draggingFrame(for: location))
  }
  
  func didPinchStarted() {
    model.setStartedPinch()
  }
  
  func didScale(with scale: CGFloat) {
    view?.setImageFrame(model.scalingFrame(for: scale))
  }
  
  func centerImage() {
    view?.transformImage(with: model.centerFrame())
  }
  
  func crop() {
    view?.activityIndicator(true)
    DispatchQueue.global(qos: .userInitiated).async {
      let image = self.model.crop()
      // Bounce back to the main thread to update the UI
      DispatchQueue.main.async {
        self.view?.activityIndicator(false)
        self.router.finish(with: image)
      }
    }
  }
  
  func cancel() {
    router.cancel()
  }
}



