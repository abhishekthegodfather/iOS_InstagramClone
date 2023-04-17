//
//  HelperMethods.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HelperMethods {
    class func showErrorMessage(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(okAction)
        return alert
    }
    
    class func VerifiedAfterLoginProcess(){
        // accessing the app delegate file and also accessing the window object
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let window = appDelegate?.window else {
            return
        }
        
        let tabController = UITabBarController()
        let homeStroyboard = UIStoryboard(name: Constants.homeStoryBoardName, bundle: nil)
        let searchStoryboard = UIStoryboard(name: Constants.searchStoryBoardName, bundle: nil)
        let newPostStroyboard = UIStoryboard(name: Constants.newPostStoryBoardName, bundle: nil)
        let profileStoryboard = UIStoryboard(name: Constants.profileStoryBoardName, bundle: nil)
        let activityStroyboard = UIStoryboard(name: Constants.activityStoryBoardName, bundle: nil)
        
        
        let homeVC = homeStroyboard.instantiateViewController(withIdentifier: Constants.homeVCID) as? HomeViewController
        let searchVC = searchStoryboard.instantiateViewController(withIdentifier: Constants.searchVCID) as? SearchViewController
        let newPostVC = newPostStroyboard.instantiateViewController(withIdentifier: Constants.newPostVCID) as? NewPostViewController
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: Constants.profileVCID) as? ProfileViewController
        let activityVC = activityStroyboard.instantiateViewController(withIdentifier: Constants.activityVCID) as? ActivityViewController
        
        let vcData : [(UIViewController, UIImage, UIImage)] = [
            (homeVC ?? UIViewController(), UIImage(named: "home_tab_icon") ?? UIImage(), UIImage(named: "home_selected_tab_icon") ?? UIImage()),
            (searchVC ?? UIViewController(), UIImage(named: "search_tab_icon") ?? UIImage(), UIImage(named: "search_selected_tab_icon") ?? UIImage()),
            (newPostVC ?? UIViewController(), UIImage(named: "post_tab_icon") ?? UIImage(), UIImage(named: "post_tab_icon") ?? UIImage()),
            (activityVC ?? UIViewController(), UIImage(named: "activity_tab_icon") ?? UIImage(), UIImage(named: "activity_selected_tab_icon") ?? UIImage()),
            (profileVC ?? UIViewController(), UIImage(named: "profile_tab_icon") ?? UIImage(), UIImage(named: "profile_selected_tab_icon") ?? UIImage()),
            ]
        
        let vcs = vcData.map { (viewControllers, defaultImages, selectedImages) -> UINavigationController in
            let nav = UINavigationController(rootViewController: viewControllers)
            nav.tabBarItem.image = defaultImages
            nav.tabBarItem.selectedImage = selectedImages
            return nav
        }
        
        
        tabController.viewControllers = vcs
        tabController.delegate = tabBarDelegate
        tabController.tabBar.tintColor = UIColor.black
//        tabController.tabBar.isTranslucent = false
        if let items = tabController.tabBar.items {
            for item in items {
                if let image = item.image {
                    item.image = image.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
                
                if let selectedImage = item.image {
                    item.image = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
                
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        
//        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.white
        window.rootViewController = tabController
    }
    
    
    class func verifiedLoginScreen(){
        do{
            try Auth.auth().signOut()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let window = appDelegate?.window else {
                return
            }
            let loginStoryBoard = UIStoryboard(name: Constants.loginScrrenStoryBoard, bundle: nil)
            let loginScreenViewController = loginStoryBoard.instantiateViewController(withIdentifier: Constants.loginScreenVCID) as? LoginViewController
            
            window.rootViewController = loginScreenViewController
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
}
