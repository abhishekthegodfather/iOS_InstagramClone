//
//  ProfileHeaderTableViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var profileType : ProfileViewConstant.ProfileConstant = .personalUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareFollowBtn()
    }
    
    func prepareFollowBtn(){
        followBtn.addTarget(self, action: #selector(followAction(_ :)), for: .touchUpInside)
        followBtn.layer.borderWidth = CGFloat(0.5)
        followBtn.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.0).cgColor
        followBtn.layer.cornerRadius = CGFloat(3.0)
    }
    
    
    @objc func followAction(_ sender: UIButton){
        switch profileType {
        case .personalUser:
            logout()
            break
        case .otherUser:
            followUser()
            break
        }
    }
    
    override func layoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        
    }
    
    func logout(){
        print("logout")
    }
    
    func followUser(){
        print("follow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static let cellId = Constants.ProfileHeaderTableViewCellId
    static func nib() -> UINib{
        return UINib(nibName: Constants.ProfileHeaderTableViewCellXib, bundle: nil)
    }
    
}
