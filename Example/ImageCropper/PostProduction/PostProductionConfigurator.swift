//
//  ⚡️Created by Generatus⚡️ on 29.05.2018
//
//  PostProductionConfigurator.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import Foundation

protocol PostProductionConfigurator {

  static func configure(for view: PostProductionViewController)

}

class PostProductionConfiguratorImplementation {
  
}

extension PostProductionConfiguratorImplementation: PostProductionConfigurator {

  static func configure(for view: PostProductionViewController) {

    let router = PostProductionRouterImplementation(for: view)
    
    let presenter = PostProductionPresenterImplementation(for: view, with: router)
    view.presenter = presenter

  }

}







