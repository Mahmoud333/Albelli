//
//  ImageViewRouter.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit

class ImageViewRouter: ImageViewRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(imageId: String) -> UIViewController {
        let view = ImageViewController()
        let interactor = ImageViewInteractor()
        let router = ImageViewRouter()
        let presenter = ImageViewPresenter(view: view, interactor: interactor, router: router, imageId: imageId)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
    
    func popViewController() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
}
