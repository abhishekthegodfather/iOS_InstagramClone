//
//  LibraryCollectionViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewLib: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.libCollectionViewXib, bundle: nil)
    }
    
    static let cellID = Constants.libCollectionViewCellID
    

}
