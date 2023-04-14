//
//  ActivityViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var CustomSegement: CustomSegmentedView!{
        didSet{
            CustomSegement.delegate = self
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    var segmentCurrentIndex : Int = 0
    var activityViewArray : [ActivityView] = {
        let followingModel = FollowingActivityModel()
        let followActivityView = Bundle.main.loadNibNamed(Constants.ActivityNibName, owner: nil, options: nil)?.first as? ActivityView
        followActivityView?.activityData = followingModel.followingActivity
        
        let youModel = YouActivityModel()
        let youActivityView = Bundle.main.loadNibNamed(Constants.ActivityNibName, owner: nil, options: nil)?.first as? ActivityView
        youActivityView?.activityData = youModel.youActivity
        return [followActivityView ?? ActivityView(), youActivityView ?? ActivityView()]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView(activityViewArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension ActivityViewController : UIScrollViewDelegate {
    func setupScrollView(_ slidesView : [ActivityView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        // This func is important when implementation of scroll view
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(slidesView.count), height: self.view.frame.height)
        scrollView.isPagingEnabled = true
        
        
        for slide in 0..<slidesView.count {
            slidesView[slide].frame = CGRect(x: self.view.frame.size.width * CGFloat(slide), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            scrollView.addSubview(slidesView[slide])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / self.view.frame.size.width)
        CustomSegement.updatedSegmentedControl(Int(pageIndex))
        segmentCurrentIndex = Int(pageIndex)
    }
}


extension ActivityViewController : ActivityDelegate {
    func scrollToIndex(_ indexOfSegementedControl: Int) {
        if segmentCurrentIndex == indexOfSegementedControl {
            return
        }else{
            let pageWidth : CGFloat = self.scrollView.frame.size.width
            let scrollToX = pageWidth * CGFloat(indexOfSegementedControl)
            self.scrollView.scrollRectToVisible(CGRect(x: scrollToX, y: 0, width: pageWidth, height: self.scrollView.frame.size.height), animated: true)
        }
    }
}
