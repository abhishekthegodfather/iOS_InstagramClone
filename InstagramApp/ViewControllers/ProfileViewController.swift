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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts : [Post] = []
    var profileType : ProfileViewConstant.ProfileConstant = .personalUser
    var user : UserModel?
    var profileImagePicker : UIImagePickerController?
    
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
    
    func uploadImageToFirebase(data: Data){
        if let user = Auth.auth().currentUser {
            self.imageUplaodProgressBar.isHidden = false
            self.cancelProgressView.isHidden = false
            self.imageUplaodProgressBar.progress = Float(0)
            
            var uploadedImageId = UUID().uuidString.lowercased()
            uploadedImageId = uploadedImageId.replacingOccurrences(of: "-", with: "_")
            
            let uploadImageName = "\(uploadedImageId).jpg"
            let pathOfUploadedFileinFirebaseDB = "images/\(user.uid)/\(uploadImageName)"
            
            var uploadedImageMetaData = StorageMetadata()
            uploadedImageMetaData.contentType = "image/jpg"
            
            let storageRefFirebaseDB = Storage.storage().reference(withPath: pathOfUploadedFileinFirebaseDB)
            uploadDataTask = storageRefFirebaseDB.putData(data, metadata: uploadedImageMetaData, completion: { [weak self] (metaData, error) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.imageUplaodProgressBar.isHidden = true
                    strongSelf.cancelProgressView.isHidden = true
                }
                
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: "Error in uploading image", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    strongSelf.present(alert, animated: true)
                }else{
                    // create a DB Entry
                    UserModel.firebaseDBReference.child(user.uid).updateChildValues(["profile_image": uploadImageName])
                }
            })
            
            uploadDataTask?.observe(.progress, handler: {[weak self] (snapshot) in
                guard let strongSelf = self else { return }
                let percentageDatataskCompleted = 100 * Double(snapshot.progress?.completedUnitCount ?? Int64(0.0)) / Double(snapshot.progress?.totalUnitCount ?? Int64(0.0))
                DispatchQueue.main.async {
                    strongSelf.imageUplaodProgressBar.setProgress(Float(percentageDatataskCompleted), animated: true)
                }
            })
            
        }
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



extension ProfileViewController : profileImageDidTouch {
    func showProfileImageAfterTouch() {
        profileImagePicker = UIImagePickerController()
        let chooseOptionsAlert = UIAlertController(title: "Change Profile image", message: "Choose a option to chnage the profile photo", preferredStyle: .actionSheet)
        let photoLibraryOption = UIAlertAction(title: "Import From Library", style: .default) { [weak self] (action) in
            guard let strongSelf = self else  { return }
            strongSelf.profileImagePicker?.sourceType = .photoLibrary
            strongSelf.profileImagePicker?.allowsEditing = true
            strongSelf.present(strongSelf.profileImagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        
        let cameraOption = UIAlertAction(title: "Take Photo", style: .default) { [weak self] (action) in
            guard let strongSelf = self else  { return }
            strongSelf.profileImagePicker?.allowsEditing = true
            strongSelf.profileImagePicker?.sourceType = .camera
            strongSelf.present(strongSelf.profileImagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            chooseOptionsAlert.dismiss(animated: true, completion: nil)
        }
        
        chooseOptionsAlert.addAction(photoLibraryOption)
        chooseOptionsAlert.addAction(cameraOption)
        chooseOptionsAlert.addAction(cancel)
        self.present(chooseOptionsAlert, animated: true, completion: nil)
        
    }
}
