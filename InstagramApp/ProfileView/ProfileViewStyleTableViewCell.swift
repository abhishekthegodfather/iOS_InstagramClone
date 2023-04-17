//
//  ProfileViewStyleTableViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class ProfileViewStyleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button1.addTarget(self, action: #selector(button1Action(_ :)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Action(_ :)), for: .touchUpInside)
        button1.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func button1Action(_ sender: UIButton){
        
    }
    
    @objc func button2Action(_ sender: UIButton){
        
    }
    
    static let cellId = Constants.ProfileViewStyleTableViewCellID
    static func nib() -> UINib {
        return UINib(nibName: Constants.ProfileViewStyleTableViewCellXib, bundle: nil)
    }
    
}
