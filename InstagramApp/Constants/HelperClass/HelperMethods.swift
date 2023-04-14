//
//  HelperMethods.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit

class HelperMethods {
    class func showErrorMessage(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        return alert
    }
}
