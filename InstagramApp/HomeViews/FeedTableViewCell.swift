//
//  FeedTableViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    
//    @IBOutlet weak var buttonView: UIView!
    
    var buttonCount : UIButton?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareImageView()
        selectionStyle = UITableViewCell.SelectionStyle.none
        
//        self.buttonCount = UIButton(frame: CGRect(x: 0, y: 0, width: self.buttonView.frame.size.width, height: self.buttonView.frame.size.height))
//        self.buttonView.addSubview(self.contentView)
//        self.buttonCount?.setTitle("Counts", for: .normal)
        
    
    }
    
    
    func prepareImageView(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        self.profileImage.layer.masksToBounds = true
        self.likeBtn.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            self.likeBtn.setImage(UIImage(systemName: "heart") ?? UIImage(), for: .normal)
            self.likeBtn.tintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        
        self.commentBtn.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            self.commentBtn.setImage(UIImage(systemName: "paperclip.circle") ?? UIImage(), for: .normal)
            self.commentBtn.tintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        
        self.sendBtn.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            self.sendBtn.setImage(UIImage(systemName: "location") ?? UIImage(), for: .normal)
            self.sendBtn.tintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        
        self.storeBtn.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            self.storeBtn.setImage(UIImage(systemName: "bookmark") ?? UIImage(), for: .normal)
            self.storeBtn.tintColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        
//        self.commentCount.setTitle("", for: .normal)
        self.commentCount.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        self.moreBtn.setTitle("", for: .normal)
    }

    static func nib() -> UINib{
        return UINib(nibName: Constants.feedTableViewXibName, bundle: nil)
    }
    
    static let cellId = Constants.feedTableViewCellID
    
}
