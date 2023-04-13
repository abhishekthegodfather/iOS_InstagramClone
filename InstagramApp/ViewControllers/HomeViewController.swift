//
//  HomeViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var posts : [Post] = {
        let model = Model()
        return model.postList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        // Do any additional setup after loading the view.
    }
    
    func prepareTableView() {
        tableView.estimatedRowHeight = CGFloat(88.0)
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(StoryTableViewCell.nib(), forCellReuseIdentifier: StoryTableViewCell.cellId)
        tableView.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.cellId)
        
        var rightImageIcon = UIImage(named: "send_nav_icon")
        rightImageIcon = rightImageIcon?.withRenderingMode(.alwaysOriginal)
        
        var leftImageIcon = UIImage(named: "camera_nav_icon")
        leftImageIcon = leftImageIcon?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImageIcon, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImageIcon, style: .plain, target: self, action: nil)
        
        var homeImageIcon = UIImage(named: "logo_nav_icon")
        self.navigationItem.titleView = UIImageView(image: homeImageIcon ?? UIImage())
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.cellId, for: indexPath) as? StoryTableViewCell
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellId, for: indexPath) as? FeedTableViewCell
        let currentIndex : Int = indexPath.row - 1
        let postData = posts[currentIndex]
        cell?.profileImage.image = postData.user.profileImage
        cell?.bigImage.image = postData.postImage
        cell?.someLabel.text = postData.datePosted
        cell?.label1.text = "\(postData.likesCount) likes"
        cell?.label2.text = postData.postComment
        cell?.titleBtn.setTitle(postData.user.name, for: .normal)
        cell?.commentCount.setTitle("View all \(postData.commentCount) Comments", for: .normal)
//        cell?.commentCount.text = "View all \(postData.commentCount) Comments"
        return cell ?? UITableViewCell()
    }
}

