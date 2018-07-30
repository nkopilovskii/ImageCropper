//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
// 
//  MainViewController.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  var presenter: MainPresenter?
  
  @IBOutlet private weak var imgPreview: UIImageView!
  @IBOutlet private var btnsFigures: [UIButton]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    MainConfiguratorImplementation.configure(for: self)
    presenter?.viewDidLoad()
  }
  
  @IBAction func btnPressed(_ sender: UIButton) {
    presenter?.cropFigure(sender.tag)
  }
  
  @IBAction func btnGetImagePressed(_ sender: UIButton) {
    presenter?.getImage()
  }
  
}

//MARK: - MainView
extension MainViewController: MainView {
  func isBtnsFiguresEnable(_ enable: Bool) {
    btnsFigures.forEach { btn in
      btn.isEnabled = enable
    }
  }
}

//MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      return
    }
    imgPreview.image = image
    presenter?.didSelect(UIImagePNGRepresentation(image)!)
  }
}
