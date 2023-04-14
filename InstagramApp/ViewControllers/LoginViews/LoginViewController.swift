//
//  LoginViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var animetedViewThing: AnimatedGradient!
    @IBOutlet weak var scrollView: UIScrollView!
    var keyboardNotifiaction : Notification?
    var activeField: UITextField?
    
    lazy var touchView = {
        let sView = UIView()
        sView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_ :)))
        sView.addGestureRecognizer(tapGesture)
        sView.isUserInteractionEnabled = true
        sView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        return sView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepThings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animetedViewThing.startAnimating()
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        deregisterForKeyboardNotifcation()
    }
    
    
    @objc func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(_ :)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_ :)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    
    func deregisterForKeyboardNotifcation(){
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown(_ notification: Notification){
        view.addSubview(touchView)
        self.keyboardNotifiaction = notification
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + 10.0), right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = UIScreen.main.bounds
        aRect.size.height -= keyboardSize!.height
        if activeField != nil {
            if (!aRect.contains(activeField!.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHidden(_ notification: Notification){
        touchView.removeFromSuperview()
        let contentInsert = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsert
        self.scrollView.scrollIndicatorInsets = contentInsert
    }
    
    func prepThings(){
        self.loginBtn.layer.borderWidth = CGFloat(0.5)
        self.loginBtn.layer.borderColor = UIColor.white.cgColor
        self.loginBtn.layer.cornerRadius = CGFloat(3.0)
        textField1.delegate = self
        textField2.delegate = self
        self.signupBtn.addTarget(self, action: #selector(signupAction(_ :)), for: .touchUpInside)
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func signupAction(_ sender: UIButton){
        performSegue(withIdentifier: "signUpSegueNameID", sender: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

}
