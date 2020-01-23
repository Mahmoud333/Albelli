//
//  MainViewProtocol.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit


protocol MainViewProtocol: class {
    var presenter: MainViewPresenterProtocol! { get set }
    func reloadCollectionView()
}

protocol MainViewPresenterProtocol: class {
    var view: MainViewProtocol? { get set }
    
    func viewDidLoad()
    func viewDidAppear()
    
    func numberOfItems() -> Int
    func configuerCollectionCell(_ cell: CollectionViewImageCell, indexPath: IndexPath, size: CGSize)
    func didSelectCollectionCell(_ indexPath: IndexPath)

}

protocol MainViewInteractorInputProtocol {
    var presenter: MainViewInteractorInteractorOutputProtocol? { get set }
}

protocol MainViewInteractorInteractorOutputProtocol: class { }

protocol MainViewRouterProtocol {
    static func createInitForApp() -> UINavigationController
    static func createModule() -> UIViewController
    func pushImageViewController(imageId: String)
}

