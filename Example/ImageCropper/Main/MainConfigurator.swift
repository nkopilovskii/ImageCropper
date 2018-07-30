//
//  ⚡️Created by Generatus⚡️ on 28.05.2018
//
//  MainConfigurator.swift
//
//  Created by NickKopilovskii
//  Copyright © NickKopilovskii. All rights reserved.
//

import Foundation

protocol MainConfigurator {

  static func configure(for view: MainViewController)

}

class MainConfiguratorImplementation {
  
}

extension MainConfiguratorImplementation: MainConfigurator {

  static func configure(for view: MainViewController) {

    let router = MainRouterImplementation(for: view)
    
    let presenter = MainPresenterImplementation(for: view, with: router)
    view.presenter = presenter

  }

}
