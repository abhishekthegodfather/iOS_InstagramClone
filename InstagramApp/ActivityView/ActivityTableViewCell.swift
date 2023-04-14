//
//  ActivityTableViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var labelDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.masksToBounds = true
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.ActivityTableViewCellXib, bundle: nil)
    }
    
    static let cellId = Constants.ActivityTableViewCellID
    
}
