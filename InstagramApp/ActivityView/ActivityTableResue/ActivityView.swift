//
//  ActivityView.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    var activityData : [Activity] = [Activity](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityTableViewCell.nib(), forCellReuseIdentifier: ActivityTableViewCell.cellId)
        tableView.tableFooterView = UIView()
    }
}


extension ActivityView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.cellId, for: indexPath) as? ActivityTableViewCell
        cell?.profileImageView.image = self.activityData[indexPath.row].userImage
        cell?.labelDetails.text = self.activityData[indexPath.row].details
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
}
