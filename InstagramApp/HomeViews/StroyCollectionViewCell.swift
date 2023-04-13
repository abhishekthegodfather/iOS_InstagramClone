//
//  StroyCollectionViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class StroyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stroyImageView: UIImageView!
    @IBOutlet weak var stroyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.storyCollectionViewCellXibName, bundle: nil)
    }
    
    static let cellId = Constants.storyCollectionViewCellIdentifer

}
