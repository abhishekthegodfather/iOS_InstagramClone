//
//  NewPostPageViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class NewPostPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var orderedController : [UIViewController] = []
    var currentViewControllerIndex : Int = 0
    var pagesToBeShown : [NewPageConstants.newPageToShow] = NewPageConstants.newPageToShow.pageToBeingShown()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        preparePageViewControllerBeforeStarting()
    }
    
    func preparePageViewControllerBeforeStarting(){
        for pageType in self.pagesToBeShown{
            let pageViewController = prepareCurrentViewController(pageType)
            self.orderedController.append(pageViewController)
        }
        
        if let firstStartViewController = self.orderedController.first {
            setViewControllers([firstStartViewController], direction: .forward, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostNotificationAction(_ :)), name: NSNotification.Name("newPostsAction"), object: nil)
    }
    
    
    @objc func newPostNotificationAction(_ notification: Notification){
        if let receviedNotifedObject = notification.object as? NewPageConstants.newPageToShow {
            presentCurrentControllerAfterPrepare(receviedNotifedObject.rawValue)
        }
    }
    
    func prepareCurrentViewController(_ pagesTobeSeen: NewPageConstants.newPageToShow) -> UIViewController {
        var currentViewController : UIViewController?
        var newPostStroyBoard = UIStoryboard(name: Constants.newPostStoryBoardName, bundle: nil)
        switch pagesTobeSeen {
        case .camera:
            currentViewController = newPostStroyBoard.instantiateViewController(withIdentifier: Constants.CameraVCID) as? CameraViewController
            break
        case .library:
            currentViewController = newPostStroyBoard.instantiateViewController(withIdentifier: Constants.LibraryVCID) as? LibraryViewController
            break
        }
        return currentViewController ?? UIViewController()
    }
    
    func presentCurrentControllerAfterPrepare(_ index: Int){
        if self.currentViewControllerIndex > index {
            self.setViewControllers([orderedController[index]], direction: .reverse, animated: true)
        }else if self.currentViewControllerIndex < index {
            setViewControllers([orderedController[index]], direction: .forward, animated: true)
        }
        
        self.currentViewControllerIndex = index
    }
    
    // Its is nessary to remove all observer of notification center
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("newPostsAction"), object: self)
    }
}

extension NewPostPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVControllerIndex = orderedController.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousControllerIndex = currentVControllerIndex - 1
        if previousControllerIndex >= 0 {
            return nil
        }
        return orderedController[previousControllerIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVControllerIndex = orderedController.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextControllerIndex = currentVControllerIndex + 1
        if nextControllerIndex == orderedController.count {
            return orderedController[nextControllerIndex]
        }else if nextControllerIndex > orderedController.count{
            return nil
        }else{
            return nil
        }
    }
}
