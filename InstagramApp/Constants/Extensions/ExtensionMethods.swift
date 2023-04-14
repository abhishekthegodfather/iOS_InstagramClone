//
//  ExtensionMethods.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func showLoadingIndicator(_ mainView: UIView) -> UIView {
        var spinerView = UIView.init(frame: mainView.bounds)
        if #available(iOS 13.0, *) {
            var laodingIndicator = UIActivityIndicatorView.init(style: .large)
            laodingIndicator.startAnimating()
            laodingIndicator.center = spinerView.center
            DispatchQueue.main.async {
                spinerView.addSubview(laodingIndicator)
                mainView.addSubview(spinerView)
            }
        } else {
            // Fallback on earlier versions
        }
        return spinerView
    }
    
    class func removeLoadingIndicator(_ spinnerView: UIView){
        DispatchQueue.main.async {
            spinnerView.removeFromSuperview()
        }
    }
}
