//
//  extensionProfileCells.swift
//  InstagramApp
//
//  Created by Cubastion on 17/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit


extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if let resizedUserImage = userPickedImage.resize(1080){
                // decresing the quality of photo of 25% need for better optimization of space
                if let profileImageJPEGData = resizedUserImage.jpegData(compressionQuality: 0.75) {
                    self.uploadImageToFirebase(data: profileImageJPEGData)
                }
            }
        }
    }
}
