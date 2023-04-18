//
//  CreatePostsViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 18/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreatePostsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var imagviewPost: UIImageView!
    
    var keyboardNotification : Notification?
    var postImage : UIImage?
    var activeTextView : UITextView?
    
    lazy var touchView : UIView = {
        var viewThing = UIView()
        viewThing.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        var tapRecog = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_ :)))
        viewThing.addGestureRecognizer(tapRecog)
        viewThing.isUserInteractionEnabled = true
        viewThing.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        return viewThing
    }()
    
    lazy var imageUplaodProgressBar : UIProgressView = {
        var _progressView = UIProgressView()
        _progressView.trackTintColor = .lightGray
        _progressView.progressTintColor = .black
        _progressView.progress = Float(0)
        _progressView.translatesAutoresizingMaskIntoConstraints = true
        return _progressView
    }()
    
    lazy var cancelProgressView : UIButton = {
        var _cancelButton = UIButton()
        _cancelButton.addTarget(self, action: #selector(cancelProgressAction(_ :)), for: .touchUpInside)
        _cancelButton.setTitle("Cancel", for: .normal)
        _cancelButton.setTitleColor(.black, for: .normal)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = true
        return _cancelButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
        postBtn.addTarget(self, action: #selector(postAction(_ :)), for: .touchDown)
        imagviewPost.image = postImage
        captionTextView.layer.cornerRadius = 3.0
        captionTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        captionTextView.layer.borderWidth = 0.5
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerForKeyboardNotification()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        deregisterForKeyboardNotifcation()
    }
    
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(_ :)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisapper(_ :)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotifcation(){
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object:  nil)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func keyboardShown(_ notification: Notification){
        self.view.addSubview(self.touchView)
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + 10.0), right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = UIScreen.main.bounds
        aRect.size.height -= keyboardSize!.height
        if activeTextView != nil {
            if (aRect.contains(activeTextView!.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardDisapper(_ notification: Notification){
        touchView.removeFromSuperview()
        let contentInsert = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsert
        self.scrollView.scrollIndicatorInsets = contentInsert
    }
    
    
    @objc func postAction(_ sender: UIButton){
        
    }
}


extension CreatePostsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
}
