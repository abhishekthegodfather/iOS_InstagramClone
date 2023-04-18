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
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts : [Post] = []
    var profileType : ProfileViewConstant.ProfileConstant = .personalUser
    var user : UserModel?
    var profileImagePicker : UIImagePickerController = UIImagePickerController()
    
    lazy var imageUplaodProgressBar : UIProgressView = {
        var _progressView = UIProgressView()
        _progressView.trackTintColor = .lightGray
        _progressView.progressTintColor = .black
        _progressView.progress = Float(0)
        _progressView.translatesAutoresizingMaskIntoConstraints = true
        return _progressView
    }()
    
    lazy var cancelProgressView : UIButton = {
        var _cancelButton = UIButton()
        _cancelButton.addTarget(self, action: #selector(cancelProgressAction(_ :)), for: .touchUpInside)
        _cancelButton.setTitle("Cancel", for: .normal)
        _cancelButton.setTitleColor(.black, for: .normal)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = true
        return _cancelButton
    }()
    
    var uploadDataTask : StorageUploadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepTableView()
        prepareAutoLayoutForProgressViewAndbutton()
        prepareForLoadData()
        profileImagePicker.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func prepareAutoLayoutForProgressViewAndbutton() {
        self.view.addSubview(imageUplaodProgressBar)
        self.view.addSubview(cancelProgressView)
        
        imageUplaodProgressBar.isHidden = true
        cancelProgressView.isHidden = true
        imageUplaodProgressBar.translatesAutoresizingMaskIntoConstraints = false
        cancelProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            imageUplaodProgressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageUplaodProgressBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageUplaodProgressBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            imageUplaodProgressBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            imageUplaodProgressBar.heightAnchor.constraint(equalToConstant: 10),
            
            cancelProgressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cancelProgressView.topAnchor.constraint(equalTo: imageUplaodProgressBar.bottomAnchor, constant: 5),
            cancelProgressView.widthAnchor.constraint(equalToConstant: 60),
            cancelProgressView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
    
    func uploadImageToFirebase(data: Data) {
        guard let user = Auth.auth().currentUser else { return }
        
        imageUplaodProgressBar.isHidden = false
        cancelProgressView.isHidden = false
        imageUplaodProgressBar.progress = 0
        
        let uploadedImageId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let uploadImageName = "\(uploadedImageId).jpg"
        let pathOfUploadedFileinFirebaseDB = "images/\(user.uid)/\(uploadImageName)"
        
        let storageRefFirebaseDB = Storage.storage().reference(withPath: pathOfUploadedFileinFirebaseDB)
        let uploadedImageMetaData = StorageMetadata()
        uploadedImageMetaData.contentType = "image/jpg"
        
        uploadDataTask = storageRefFirebaseDB.putData(data, metadata: uploadedImageMetaData) { [weak self] (metaData, error) in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.imageUplaodProgressBar.isHidden = true
                strongSelf.cancelProgressView.isHidden = true
            }
            
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: "Error in uploading image", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                strongSelf.present(alert, animated: true)
            } else {
                // create a DB Entry
                storageRefFirebaseDB.downloadURL { (downloadingUrl, error) in
                    guard let downloadURL = downloadingUrl else {
                        print(error?.localizedDescription)
                        let alert = UIAlertController(title: "Error", message: "Error in uploading image", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .default) { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(ok)
                        strongSelf.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    UserModel.firebaseDBReference.child(user.uid).updateChildValues(["profile_image": downloadURL.absoluteString])
                }
            }
        }
        
        uploadDataTask?.observe(.progress, handler: { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            
            let percentageDatataskCompleted = 100 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            
            DispatchQueue.main.async {
                strongSelf.imageUplaodProgressBar.setProgress(Float(percentageDatataskCompleted), animated: true)
            }
        })
    }

    
    @objc func cancelProgressAction(_ sender : UIButton) {
        self.imageUplaodProgressBar.isHidden = false
        self.cancelProgressView.isHidden = false
        uploadDataTask?.cancel()
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
            cell?.delegate = self
            cell?.namelabel.text = ""
            if let user = self.user {
                cell?.namelabel.text = user.profileName
                if let proImg = user.profileImageRef {
                    cell?.profileImageView.sd_cancelCurrentImageLoad()
                    if #available(iOS 13.0, *) {
                        cell?.profileImageView.sd_setImage(with: proImg, placeholderImage: UIImage(systemName: "person.circle"), completed: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
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



