//
//  ImageViewProtocol.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import Foundation
import WebKit

protocol ImageViewProtocol: class {
    var presenter: ImageViewPresenterProtocol! { get set }
    func loadPage(_ html: String, url: URL) 
}

protocol ImageViewPresenterProtocol: class {
    var view: ImageViewProtocol? { get set }
    
    var doneButtonJSHandler: String! { get } 
    var imageId: String { get set }
    
    func viewDidAppear()
    
    func webViewDidReceive(_ name: String, body: Any)
}

protocol ImageViewInteractorInputProtocol {
    var presenter: ImageViewInteractorInteractorOutputProtocol? { get set }
}

protocol ImageViewInteractorInteractorOutputProtocol: class { }

protocol ImageViewRouterProtocol {
    static func createModule(imageId: String) -> UIViewController
    func popViewController()
}

