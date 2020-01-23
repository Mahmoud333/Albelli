//
//  ViewController.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainViewPresenterProtocol!
    
    private var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cell"
    private lazy var cellSize = CGSize(width: view.bounds.size.width / 2, height: view.bounds.size.width / 2)
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    //MARK:- Setup
    func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: {
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                return layout
        }()
        )
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewImageCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.addSubview(collectionView)
    }
    
    //MARK:- Helpers
    func reloadCollectionView() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
}

//MARK:- CollectionView
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
            ) as! CollectionViewImageCell
        
        presenter.configuerCollectionCell(cell, indexPath: indexPath, size: cellSize)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCollectionCell(indexPath)
    }
}
