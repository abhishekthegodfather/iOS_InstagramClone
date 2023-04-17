//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts : [Post] = []
    var profileType : ProfileViewConstant.ProfileConstant = .personalUser
    var user : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepTableView()
        prepareForLoadData()
    }
    
    func prepareForLoadData(){
        guard let firebaseUserId = Auth.auth().currentUser?.uid else { return }
        let DBRef = UserModel.firebaseDBReference.child(firebaseUserId)
        let spiner = UIViewController.showLoadingIndicator(self.view)
        DBRef.observe(.value) {[weak self] (DBSnapShot) in
            print(DBSnapShot)
            guard let strongSelf = self else { return }
            guard let userModelFirebase = UserModel(DBSnapShot) else { return }
            UIViewController.removeLoadingIndicator(spiner)
            strongSelf.user = userModelFirebase
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func prepTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileHeaderTableViewCell.nib(), forCellReuseIdentifier: ProfileHeaderTableViewCell.cellId)
        tableView.register(ProfileViewStyleTableViewCell.nib(), forCellReuseIdentifier: ProfileViewStyleTableViewCell.cellId)
        tableView.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else{
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCell.cellId, for: indexPath) as? ProfileHeaderTableViewCell
            cell?.profileType = .personalUser
            cell?.namelabel.text = ""
            if let user = self.user {
                cell?.namelabel.text = user.profileName
            }
            switch profileType {
            case .personalUser:
                cell?.followBtn.setTitle("Logout", for: .normal)
                break
            case .otherUser:
                cell?.followBtn.setTitle("Follow", for: .normal)
                break
            }
            return cell ?? UITableViewCell()
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewStyleTableViewCell.cellId, for: indexPath) as? ProfileViewStyleTableViewCell
            return cell ?? UITableViewCell()
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellId, for: indexPath) as? FeedTableViewCell
            return cell ?? UITableViewCell()
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
