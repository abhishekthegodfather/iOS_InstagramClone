//
//  extensionProfileCells.swift
//  InstagramApp
//
//  Created by Cubastion on 17/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if let resizedUserImage = userPickedImage.resize(1080) {
                // Decrease the quality of photo by 25% for better optimization of space
                if let profileImageJPEGData = resizedUserImage.jpegData(compressionQuality: 0.75) {
                    self.uploadImageToFirebase(data: profileImageJPEGData)
                } else {
                    // Handle error if unable to create JPEG data
                    let alert = UIAlertController(title: "Error", message: "Unable to create JPEG data for the selected image", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    present(alert, animated: true)
                }
            } else {
                // Handle error if unable to resize image
                let alert = UIAlertController(title: "Error", message: "Unable to resize the selected image", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                present(alert, animated: true)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController : profileImageDidTouch {
    func showProfileImageAfterTouch() {
        let chooseOptionsAlert = UIAlertController(title: "Change Profile image", message: "Choose a option to chnage the profile photo", preferredStyle: .actionSheet)
        let photoLibraryOption = UIAlertAction(title: "Import From Library", style: .default) { [weak self] (action) in
            guard let strongSelf = self else  { return }
            strongSelf.profileImagePicker.sourceType = .photoLibrary
            strongSelf.profileImagePicker.allowsEditing = true
            strongSelf.present(strongSelf.profileImagePicker, animated: true, completion: nil)
        }
        
        let cameraOption = UIAlertAction(title: "Take Photo", style: .default) { [weak self] (action) in
            guard let strongSelf = self else  { return }
            strongSelf.profileImagePicker.allowsEditing = true
            strongSelf.profileImagePicker.sourceType = .camera
            strongSelf.present(strongSelf.profileImagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            chooseOptionsAlert.dismiss(animated: true, completion: nil)
        }
        
        chooseOptionsAlert.addAction(photoLibraryOption)
        chooseOptionsAlert.addAction(cameraOption)
        chooseOptionsAlert.addAction(cancel)
        self.present(chooseOptionsAlert, animated: true, completion: nil)
        
    }
}

