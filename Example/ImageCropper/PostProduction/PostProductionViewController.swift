//
//  ⚡️Created by Generatus⚡️ on 29.05.2018
// 
//  PostProductionViewController.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

class PostProductionViewController: UIViewController {
  
  var presenter: PostProductionPresenter?
  
  var image: UIImage?
  
  
  @IBOutlet private weak var imgResult: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    PostProductionConfiguratorImplementation.configure(for: self)
    presenter?.viewDidLoad()
    imgResult.image = image
    
    guard let width = image?.size.width, let height = image?.size.height else { return }
    let constraint = NSLayoutConstraint(item: imgResult, attribute: .width, relatedBy: .equal, toItem: imgResult, attribute: .height, multiplier: width / height, constant: 0)
    imgResult.addConstraint(constraint)
    imgResult.layer.borderWidth = 1
    imgResult.layer.borderColor = UIColor.black.cgColor
  }

  @IBAction func btnBackPressed(_ sender: Any) {
    presenter?.back()
  }
  
  @IBAction func btnDonePressed(_ sender: Any) {
    presenter?.done()
    
  }
}

//MARK: - PostProductionView

extension PostProductionViewController: PostProductionView {
  
}
