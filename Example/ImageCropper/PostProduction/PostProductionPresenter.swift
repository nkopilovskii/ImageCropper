//
//  ⚡️Created by Generatus⚡️ on 29.05.2018
// 
//  PostProductionPresenter.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import Foundation

protocol PostProductionView: class {
  
}

protocol PostProductionPresenter {

  func viewDidLoad()
  func back()
  func done()
}

protocol PostProductionRouter {
  func backToPrevious()
  func goToNext()
}

class PostProductionPresenterImplementation {

  private weak var view: PostProductionView?
  
  private let router: PostProductionRouter
  
  //MARK: -
  
  init(for view: PostProductionView, with router: PostProductionRouter) {

    self.view = view
    self.router = router

  }

}

//MARK: - PostProductionPresenter

extension PostProductionPresenterImplementation: PostProductionPresenter {

  func viewDidLoad() {
    
  }
  
  func back() {
    router.backToPrevious()
  }
  
  func done() {
    router.goToNext()
  }

}



