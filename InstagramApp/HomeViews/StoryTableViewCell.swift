//
//  StoryTableViewCell.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    lazy var story : [Story] = {
        let model = Model()
        return model.storyList
    }()

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        prepareForCollectionView()
    }
    
    func prepareForCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StroyCollectionViewCell.nib(), forCellWithReuseIdentifier: StroyCollectionViewCell.cellId)
    }

    static func nib() -> UINib {
        return UINib(nibName: Constants.storyTableViewCellXibName, bundle: nil)
    }
    
    static let cellId = Constants.storyTableViewCellIdentifer
}


extension StoryTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return story.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StroyCollectionViewCell.cellId, for: indexPath) as? StroyCollectionViewCell
        cell?.stroyImageView.image = story[indexPath.row].post.postImage
        cell?.stroyLabel.text = story[indexPath.row].post.user.name
        cell?.stroyImageView.layer.cornerRadius = (cell?.stroyImageView.frame.size.width)!/2
        cell?.stroyImageView.layer.masksToBounds = true
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 110)
    }
}
