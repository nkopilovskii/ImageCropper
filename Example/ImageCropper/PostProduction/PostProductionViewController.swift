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




















