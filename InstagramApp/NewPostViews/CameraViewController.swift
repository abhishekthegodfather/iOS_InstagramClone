//
//  CameraViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    
    @IBOutlet weak var simpleCameraView: SimpleCameraView!
    @IBOutlet weak var captureBtn: UIButton!
    var simpleCameraRef : SimpleCamera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureBtn.addTarget(self, action: #selector(camBtnAction(_ :)), for: .touchUpInside)
        simpleCameraRef = SimpleCamera(cameraView: simpleCameraView)
        self.captureBtn.setTitle("", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        simpleCameraRef?.startSession()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        simpleCameraRef?.stopSession()
    }
    
    @objc func camBtnAction(_ sender: UIButton){
        if simpleCameraRef?.currentCaptureMode == .photo {
            simpleCameraRef?.takePhoto(photoCompletionHandler: { imageData, success in
                if success {
                    print("Successfully photo is taken")
                }
            })
        }
    }
    
}
