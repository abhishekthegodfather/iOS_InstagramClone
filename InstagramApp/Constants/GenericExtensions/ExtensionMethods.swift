//
//  ExtensionMethods.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

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

extension UIImage {
    func resize(_ toWidth: CGFloat) -> UIImage? {
        if self.size.width <= toWidth {
            return self
        }
        
        let canvasSize = CGSize(width: toWidth, height: CGFloat(ceil(toWidth*size.height)/size.width))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer {UIGraphicsEndImageContext()}
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
