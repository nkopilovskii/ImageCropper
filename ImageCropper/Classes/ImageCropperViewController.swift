//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
// 
//  ImageCropperViewController.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

public class ImageCropperViewController: UIViewController {
  //MARK: Static initializer
  static public func initialize(with configuration:ImageCropperConfiguration, completionHandler: @escaping ImageCropperCompletion) -> ImageCropperViewController {
    let cropper = ImageCropperViewController(nibName: "ImageCropper", bundle: Bundle(for: self.classForCoder()))
    ImageCropperConfiguratorImplementation.configure(for: cropper, with: configuration, completionHandler: completionHandler)
  
    return cropper
  }
  
  static public func initialize(with configuration:ImageCropperConfiguration, completionHandler: @escaping ImageCropperCompletion, dismiss: @escaping ImageCropperDismiss) -> ImageCropperViewController {
    
    let cropper = ImageCropperViewController(nibName: "ImageCropper", bundle: Bundle(for: self.classForCoder()))
    ImageCropperConfiguratorImplementation.configure(for: cropper, with: configuration, completionHandler: completionHandler, dismiss: dismiss)
    
    return cropper
  }
  

  //MARK: Private properties & IBOutlets
  @IBOutlet fileprivate weak var imgCropping: UIImageView!
  @IBOutlet fileprivate weak var mask: UIView!
  @IBOutlet fileprivate weak var grid: UIView!
  @IBOutlet fileprivate weak var btnDone: UIButton!
  @IBOutlet fileprivate weak var btnCancel: UIButton!
  @IBOutlet fileprivate weak var bottomBar: UIView!
  
  @IBOutlet fileprivate weak var activityView: UIView!
  @IBOutlet fileprivate weak var activity: UIActivityIndicatorView!
  
  var presenter: ImageCropperPresenter?

  fileprivate var pinchStartDistance: CGFloat = 0
  
  
  //MARK:  Lifecicle
  override public func viewDidLoad() {
    super.viewDidLoad()
    presenter?.viewDidLoad()
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    presenter?.viewDidLayoutSubviews(in: view.bounds)
  }
}

//MARK: - Private
//MARK: Actions
extension ImageCropperViewController {
  @IBAction func btnCancelPressed(_ sender: UIButton) {
    presenter?.cancel()
  }
  
  @IBAction func btnDonePressed(_ sender: UIButton) {
    presenter?.crop()
  }
  
  @IBAction func actionPan(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began:
      presenter?.userInteraction(true)
      
    case .changed:
      presenter?.didDrag(to: sender.location(in: grid))
      
    case .ended:
      presenter?.userInteraction(false)
      
    default:
      return
    }
  }
  
  @IBAction func actionPinch(_ sender: UIPinchGestureRecognizer) {
    switch sender.state {
    case .began:
      guard sender.numberOfTouches >= 2 else { return }
      presenter?.userInteraction(true)
      presenter?.didPinchStarted()
    case .changed:
      guard sender.numberOfTouches >= 2 else { return }
      presenter?.didScale(with: sender.scale)
    case .ended, .cancelled:
      presenter?.userInteraction(false)
    default:
      return
    }
  }
  
  @IBAction func actionGesture(_ sender: UITapGestureRecognizer) {
    
  }
  
  @IBAction func actionDoubleTap(_ sender: UITapGestureRecognizer) {
    presenter?.centerImage()
  }
  
  func distance(from first: CGPoint, to second: CGPoint) -> CGFloat {
    
    return sqrt(pow(first.x - second.x, 2) + pow(first.y - second.y, 2))
  }
}

//MARK: - ImageCropperView

extension ImageCropperViewController: ImageCropperView {
  
  func set(_ image: UIImage) {
    imgCropping.image = image
  }
  
  func setImageFrame(_ frame: CGRect) {
    imgCropping.frame = frame
  }
  
  func transformImage(with frame: CGRect) {
    UIView.animate(withDuration: 0.2) {
      self.imgCropping.frame = frame
    }
  }
  
  func clearMask() {
    mask.layer.mask = nil
    mask.layer.sublayers?.forEach({ (sublayer) in
      sublayer.removeFromSuperlayer()
    })
  }
  
  func drawMask(by path: CGPath, with fillColor: UIColor) {
    let hole = CAShapeLayer()
    hole.frame = mask.bounds
    hole.path = path
    hole.fillRule = CAShapeLayerFillRule.evenOdd
    mask.layer.mask = hole
    mask.backgroundColor = fillColor
  }
  
  func clearBorderAndGrid() {
    grid.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
  }
  
  func drawBorber(by path: CGPath, with strokeColor: CGColor) {
    let border = CAShapeLayer()
    border.frame = grid.bounds
    border.path = path
    border.fillColor = UIColor.clear.cgColor
    border.strokeColor = strokeColor
    border.lineWidth = 4
    grid.layer.addSublayer(border)
  }
  
  func drawGrid(with lines: [CGPath], with strokeColor: CGColor) {
    lines.forEach {
      let lineLayer = CAShapeLayer()
      lineLayer.path = $0
      lineLayer.fillColor = nil
      lineLayer.opacity = 1
      lineLayer.lineWidth = 1
      lineLayer.strokeColor = strokeColor
      grid.layer.insertSublayer(lineLayer, at: 0)
    }
  }

  
  func setDone(_ title: String?) {
    guard let t = title else { return }
    btnDone.setTitle(t, for: .normal)
  }
  
  func setCancel(_ title: String?) {
    guard let t = title else { return }
    btnCancel.setTitle(t, for: .normal)
  }
  
  func showBottomButtons(_ show: Bool) {
    let alpha = show ? 1 : 0
    UIView.animate(withDuration: 0.1) {
      self.bottomBar.alpha = CGFloat(alpha)
    }
  }
  
  
  func setBackButton(title: String?, image: UIImage?, tintColor: UIColor?) {
    guard let bar = self.navigationController?.navigationBar, let backItem = bar.backItem else { return }
    backItem.title = title
    bar.backIndicatorImage = image
    bar.backIndicatorTransitionMaskImage = image
    bar.tintColor = tintColor ??  bar.tintColor
  }
  
  
  func activityIndicator(_ show: Bool) {
    activityView.isHidden = !show
  }
  
//  func setBack(title: String?) {
//    guard  let back = navigationItem.backBarButtonItem else { return }
//    guard let backTitle = title else { return }
//    back.title = backTitle
//    
//  }
//  
//  func setBack(image: UIImage?) {
//    guard let nc = navigationController, let back = nc.navigationBar.backItem?.backBarButtonItem else { return }
//    guard let backImage = image else { return }
//    back.image = backImage
//  }
//  
//  func setBack(tintColor: UIColor?) {
//    guard let nc = navigationController, let back = nc.navigationBar.backItem?.backBarButtonItem else { return }
//    guard let backTintColor = tintColor else { return }
//    back.tintColor = backTintColor
//  }
  
}

