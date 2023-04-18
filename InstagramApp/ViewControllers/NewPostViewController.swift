//
//  NewPostViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    
    @IBOutlet weak var libraryButttonAction: UIButton!
    @IBOutlet weak var photoButtonAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavbars()
        prepareBtnAction()
    }
    
    func prepareNavbars(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelAction(_ :)))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    @objc func backActionBar(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    func prepareBtnAction(){
        self.libraryButttonAction.addTarget(self, action: #selector(libAction(_ :)), for: .touchUpInside)
        self.photoButtonAction.addTarget(self, action: #selector(photoAction(_ :)), for: .touchUpInside)
    }
    
    @objc func libAction(_ sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name("newPostsActions"), object: NewPageConstants.newPageToShow.library)
    }
    
    @objc func photoAction(_ sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name("newPostsAction"), object: NewPageConstants.newPageToShow.camera)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}
