//
//  MainViewRouter.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit

class MainViewRouter: MainViewRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createInitForApp() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: MainViewRouter.createModule())
        return navigationController
    }
    
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let interactor = MainViewInteractor()
        let router = MainViewRouter()
        let presenter = MainViewPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func pushImageViewController(imageId: String) {
        let imageView = ImageViewRouter.createModule(imageId: imageId)
        self.viewController?.navigationController?.pushViewController(imageView, animated: true)
    }
}
