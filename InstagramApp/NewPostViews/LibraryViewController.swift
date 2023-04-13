//
//  LibraryViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LibraryCollectionViewCell.nib(), forCellWithReuseIdentifier: LibraryCollectionViewCell.cellID)
    }
}


extension LibraryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.cellID, for: indexPath) as? LibraryCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
}
