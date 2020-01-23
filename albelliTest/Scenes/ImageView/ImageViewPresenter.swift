//
//  ImageViewPresenter.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import Foundation
import WebKit

class ImageViewPresenter: ImageViewPresenterProtocol {
    
    weak var view: ImageViewProtocol?
    private let interactor: ImageViewInteractorInputProtocol
    private let router: ImageViewRouterProtocol
    
    //MARK:- Properties
    var doneButtonJSHandler: String! { return "doneButtonJSHandler" }
    var imageId: String
    
    
    //MARK:- Init
    init(view: ImageViewProtocol, interactor: ImageViewInteractorInputProtocol, router: ImageViewRouterProtocol, imageId: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.imageId = imageId
    }
    
    func viewDidAppear() {
        loadPage()
    }
    
    func webViewDidReceive(_ name: String, body: Any) {
        if name == doneButtonJSHandler {
            //self.navigationController?.popViewController(animated: true)
            router.popViewController()
        }
    }
    
    //MARK:- Helpers
    
    // note: implicit unwrapping is done for the sake of convenience
    // if it crashes, please let us know, it's not part of the test
    private func loadPage() {
        guard let percentEncodedId = imageId.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
            let url = URL(string: "http://localhost?imageId=\(percentEncodedId)"),
            let testPageUrl = Bundle.main.url(forResource: "testPage", withExtension: "html"),
            let html = try? String(contentsOf: testPageUrl)
        else {
            return assertionFailure("oops. not part of the test, please let us know if execution ends up here")
        }
        view?.loadPage(html, url: url)
    }
}

extension ImageViewPresenter: ImageViewInteractorInteractorOutputProtocol { }

