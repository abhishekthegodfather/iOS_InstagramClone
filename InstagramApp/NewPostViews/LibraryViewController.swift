//
//  LibraryViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit
import Photos

class LibraryViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var PhotoLibAssetsArray : [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LibraryCollectionViewCell.nib(), forCellWithReuseIdentifier: LibraryCollectionViewCell.cellID)
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.getImagesFromPhotoLibaray()
        }else {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.getImagesFromPhotoLibaray()
                    }
                    break
                case .denied, .restricted, .notDetermined:
                    return
                case .limited:
                    DispatchQueue.main.async {
                        self.getImagesFromPhotoLibaray()
                    }
                @unknown default:
                    return
                }
            }
        }
    }
    
    
    func getImagesFromPhotoLibaray(){
        let imageAsset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        imageAsset.enumerateObjects { imageObject, count, stop in
            self.PhotoLibAssetsArray.append(imageObject)
        }
        // for getting latest images
        self.PhotoLibAssetsArray.reverse()
        self.collectionView.reloadData()
    }
}


extension LibraryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.PhotoLibAssetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.cellID, for: indexPath) as? LibraryCollectionViewCell
        let asset = self.PhotoLibAssetsArray[indexPath.row]
        let manager = PHImageManager.default()
        if cell?.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell?.tag ?? 0))
        }
        cell?.tag = Int(manager.requestImage(for: asset, targetSize: CGSize(width: 120.0, height: 120.0), contentMode: .aspectFill, options: nil, resultHandler: { (result, _) in
            cell?.imageViewLib.image = result
        }))
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 30)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assets = self.PhotoLibAssetsArray[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: assets, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (results, _) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createNewPosts"), object: results)
        }
    }
    
    
}
