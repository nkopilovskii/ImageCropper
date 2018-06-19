//
//  ⚡️Created by Generatus⚡️ on 29.05.2018
// 
//  PostProductionRouter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import UIKit

class PostProductionRouterImplementation {

  private weak var view: PostProductionViewController?
  
  init(for view: PostProductionViewController) {
    self.view = view
  }

}

//MARK: - PostProductionRouter

extension PostProductionRouterImplementation: PostProductionRouter {
  func backToPrevious() {
    guard let nc = view?.navigationController else {
      view?.dismiss(animated: true, completion: nil)
      return
    }
    nc.popViewController(animated: true)
  }
  
  func goToNext() {
    guard let nc = view?.navigationController else {
      view?.dismiss(animated: true, completion: nil)
      return
    }
    nc.popToRootViewController(animated: true)
  }
  
  
}
