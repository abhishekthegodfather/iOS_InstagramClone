//
//  SearchCollectionViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    static func nib() -> UINib {
        return UINib(nibName: Constants.SearchCollectionViewXib, bundle: nil)
    }
    
    static let cellId = Constants.SearchCollectionViewCellID

}
