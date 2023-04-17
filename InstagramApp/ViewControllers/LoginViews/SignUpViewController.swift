//
//  SignUpViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var animatedView: AnimatedGradient!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField : UITextField?
    var keyboardNotification : Notification?
    
    lazy var touchView : UIView = {
        let sTouchView = UIView()
        sTouchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_ :)))
        sTouchView.addGestureRecognizer(tapGesture)
        sTouchView.isUserInteractionEnabled = true
        sTouchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        return sTouchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepThings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animatedView.startAnimation()
        registerkeyBoardAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        animatedView.stopAnimation()
        makeHideKeyboardApperence()
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func registerkeyBoardAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name:UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisapper(_ :)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    func makeHideKeyboardApperence(){
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification){
        view.addSubview(touchView)
        self.keyboardNotification = notification
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
    
    @objc func keyboardWillDisapper(_ notification: Notification){
        touchView.removeFromSuperview()
        let contentInsert = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsert
        self.scrollView.scrollIndicatorInsets = contentInsert
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func prepThings(){
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        signUpBtn.layer.cornerRadius = CGFloat(3.0)
        signUpBtn.layer.borderWidth = CGFloat(0.5)
        signUpBtn.layer.borderColor = UIColor.white.cgColor
        signinBtn.addTarget(self, action: #selector(signinBtnAction(_ :)), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(prepareSignoutProcess(_ :)), for: .touchUpInside)
        textField3.isSecureTextEntry = true
    }
    
    @objc func prepareSignoutProcess(_ sender: UIButton) {
        guard let userNameTxt = textField1.text else { return }
        guard let emailTxt = textField2.text else { return }
        guard let passwordTxt = textField3.text else { return }
        
        let spinner = UIViewController.showLoadingIndicator(self.view)
        
        Auth.auth().createUser(withEmail: emailTxt, password: passwordTxt) { [weak self] (authUser, error) in
            guard let strongSelf = self else  { return }
            
            if error == nil {
                guard let firebaseUserId = authUser?.user.uid else {
                    let alert  = HelperMethods.showErrorMessage(title: "Error", message: "Cannot get userId in firebase after account creation")
                    strongSelf.present(alert, animated: true, completion: nil)
                    return
                }
                
                Auth.auth().signIn(withEmail: emailTxt, password: passwordTxt) { (authUser, error) in
                    DispatchQueue.main.async {
                        UIViewController.removeLoadingIndicator(spinner)
                    }
                    
                    if error == nil {
                        let dataBaseRef = Database.database().reference().child("users").child(firebaseUserId)
                        dataBaseRef.updateChildValues(["username" : userNameTxt, "bio" : "welcome to instagram clone profile"])
                        DispatchQueue.main.async {
                            HelperMethods.VerifiedAfterLoginProcess()
                        }
                    }else {
                        let alert = HelperMethods.showErrorMessage(title: "Error", message: "Error in login after account creation")
                        strongSelf.present(alert, animated: true, completion: nil)
                    }
                }
            }else {
                UIViewController.removeLoadingIndicator(spinner)
                let alert = HelperMethods.showErrorMessage(title: "Error", message: "Error in signup process")
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    @objc func signinBtnAction(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}

