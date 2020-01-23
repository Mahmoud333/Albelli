//
//  MainViewPresenter.swift
//  albelliTest
//
//  Created by Mahmoud Hamad on 1/18/20.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import Foundation
import Photos


class MainViewPresenter: MainViewPresenterProtocol, MainViewInteractorInteractorOutputProtocol {

    var view: MainViewProtocol?
    private let interactor: MainViewInteractorInputProtocol
    private let router: MainViewRouterProtocol
    
    private let manager =  PHCachingImageManager() //PHImageManager.default()
    var photosFetchResult = PHFetchResult<PHAsset>()

    
    init(view: MainViewProtocol, interactor: MainViewInteractor, router: MainViewRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    func viewDidAppear() {
        getAllPhotos()
    }
    
    func configuerCollectionCell(_ cell: CollectionViewImageCell, indexPath: IndexPath, size: CGSize) {
        let asset = self.photosFetchResult.object(at: indexPath.row)
        let option = PHImageRequestOptions()
        //option.version = .original
        option.isSynchronous = true
        option.deliveryMode = .opportunistic
        
        manager.requestImage(for: asset,
                             targetSize: size,
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler: { image, info in
            guard let image = image else { return }
            cell.image = image // TODO: pass in the image
        })
    }
    
    func didSelectCollectionCell(_ indexPath: IndexPath) {
        let identifier = self.photosFetchResult.object(at: indexPath.row).localIdentifier
        router.pushImageViewController(imageId: identifier)
    }
    
    func numberOfItems() -> Int {
        return photosFetchResult.count
    }
    
    //MARK:- Helpers
    private func getAllPhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let strongSelf = self else { print("guard return: \(#line) \(#file)"); return }
            guard case .authorized = status else { return assertionFailure("not handled for the sake of simplicity") }
            strongSelf.photosFetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
            strongSelf.view?.reloadCollectionView()
        }
    }
}
