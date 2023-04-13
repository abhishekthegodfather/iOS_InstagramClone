//
//  tabBarDelegate.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit

class TabBarDelgate : NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // This ensure that when we tap on one viewcontroller and move to new page and after that new tab icon and going back to previous one doesnot show the last controller before moving to new controller this code ensure that when ever we tab on bar icon it open fresh VC from start
        let navigationControllers = viewController as? UINavigationController
        _ = navigationControllers?.popToRootViewController(animated: false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // get *Selected ViewController of optional Type (named *SelectedController)
        let selectedViewController = tabBarController.selectedViewController
        guard let selectedController = selectedViewController else {
            return false
        }
        
        // checking the selectedController with the currentViewController
        if selectedController == viewController {
            return false
        }
        
        // get the ViewControllerIndex
        guard let indexViewController = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // show the pageView Controller at viewcontroller at index 2
        if indexViewController == 2 {
            let pageViewController = UIStoryboard(name: Constants.newPostStoryBoardName, bundle: nil).instantiateViewController(withIdentifier: Constants.pageViewControllerID) as? NewPostPageViewController
            let navController = UINavigationController(rootViewController: pageViewController ??  UIPageViewController())
            selectedController.present(navController, animated: true, completion: nil)
            return false
        }
    
        // if the controller index is not 2, we need default behaviour
        let navigationControllers = viewController as? UINavigationController
        _ = navigationControllers?.popToRootViewController(animated: false)
        return true
    }
}
