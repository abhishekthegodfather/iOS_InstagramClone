//
//  AnimatedLoginView.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit

class AnimatedGradient : UIView {
    var gradient = CAGradientLayer()
    var gradientSet : [[CGColor]] = [[]]
    var currentGradient : Int = 0
    
    var gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1.0).cgColor
    var gardientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1.0).cgColor
    var gardientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1.0).cgColor
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    
    func commonInit(){
        self.gradientSet.append([gradientOne, gardientTwo])
        self.gradientSet.append([gardientTwo, gardientThree])
        self.gradientSet.append([gardientThree, gradientOne])
        self.gradient.colors = gradientSet[currentGradient]
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradient.drawsAsynchronously = true
        layer.insertSublayer(self.gradient, at: 0)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = bounds
    }
    
    
    func startAnimating(){
        var previousGradient: Int!
        if currentGradient < gradientSet.count - 1{
            currentGradient += 1
            previousGradient = currentGradient - 1
        }else {
            currentGradient = 0
            previousGradient = gradientSet.count - 1
        }
        
        let gradientChangeAnim = CABasicAnimation(keyPath: "colors")
        gradientChangeAnim.duration = 5.0
        gradientChangeAnim.fromValue = gradientSet[previousGradient]
        gradientChangeAnim.toValue = gradientSet[currentGradient]
        gradient.setValue(currentGradient, forKeyPath: "colorChange")
        gradientChangeAnim.delegate = self
        gradient.add(gradientChangeAnim, forKey: nil)
    }
    
    func stopAnimation() {
        gradient.removeAllAnimations()
    }
}


extension AnimatedGradient : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let colorChange = gradient.value(forKey: "colorChange") as? Int {
                gradient.colors = gradientSet[colorChange]
                self.startAnimating()
            }
        }
    }
}
