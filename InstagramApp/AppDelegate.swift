//
//  AppDelegate.swift
//  InstagramApp
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarDelegate = TabBarDelgate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        prepareTabController()
        
        return true
    }
    
    func prepareTabController(){
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
        window?.rootViewController = tabController
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

