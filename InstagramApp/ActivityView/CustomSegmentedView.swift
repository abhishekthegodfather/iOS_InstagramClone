//
//  CustomSegmentedView.swift
//  InstagramApp
//
//  Created by Cubastion on 14/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

protocol ActivityDelegate : AnyObject {
    func scrollToIndex(_ indexOfSegementedControl: Int)
}

class CustomSegmentedView: UIView {
    
    // prevent memory cycle
    weak var delegate : ActivityDelegate?
    var segemenedButton : [UIButton] = []
    var sectorCutterView: UIView?
    
    var segmentedButtonTitle : [String] = ["Following", "You"]
    var textAttribute : UIColor = UIColor.lightGray
    var selectedColour : UIColor = UIColor.black
    var selectedSegmentedIndex : Int = 0
    var selectorColor : UIColor = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateCustomSegmentedView()
    }
    
    // Important func for updating the SegmentedContoll UI
    func updateCustomSegmentedView(){
        self.segemenedButton.removeAll()
        subviews.forEach { otherViews in
            otherViews.removeFromSuperview()
        }
        
        for title in self.segmentedButtonTitle {
            var aSampleSegmentedButton = UIButton.init(type: .system)
            aSampleSegmentedButton.setTitle(title, for: .normal)
            aSampleSegmentedButton.setTitleColor(textAttribute, for: .normal)
            aSampleSegmentedButton.addTarget(self, action: #selector(segmentedButtonTapped(_ :)), for: .touchUpInside)
            self.segemenedButton.append(aSampleSegmentedButton)
        }
        
        self.segemenedButton[0].setTitleColor(selectorColor, for: .normal)
        let selectorWidth = self.frame.width / CGFloat(self.segmentedButtonTitle.count)
        let yPosition = (self.frame.maxY - self.frame.minY) - 2.0
        self.sectorCutterView = UIView(frame: CGRect(x: 0, y: yPosition, width: selectorWidth, height: 2))
        self.sectorCutterView?.backgroundColor = self.selectorColor
        addSubview(self.sectorCutterView ?? UIView())
        
        self.prepStackView()
    }
    
    func prepStackView(){
        let segmentedControlStackView : UIStackView = {
            let stackView = UIStackView(arrangedSubviews: segemenedButton)
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 0.0
            stackView.axis = .horizontal
            return stackView
        }()
        addSubview(segmentedControlStackView)
        segmentedControlStackView.translatesAutoresizingMaskIntoConstraints = false
        // add constraints
        segmentedControlStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        segmentedControlStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        segmentedControlStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        segmentedControlStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    @objc func segmentedButtonTapped(_ sender: UIButton){
        for (sButtonIndex, sBtn) in self.segemenedButton.enumerated() {
            sBtn.setTitleColor(textAttribute, for: .normal)
            if sBtn == sender {
                self.selectedSegmentedIndex = sButtonIndex
                delegate?.scrollToIndex(self.selectedSegmentedIndex)
            }
        }
    }
    
    
    func updatedSegmentedControl(_ index: Int) {
        for aSegmentedButton in self.segemenedButton {
            aSegmentedButton.setTitleColor(textAttribute, for: .normal)
        }
        let startSelectorPos = frame.width / CGFloat(self.segemenedButton.count) * CGFloat(index)
        UIView.animate(withDuration: 0.3) {
            self.sectorCutterView?.frame.origin.x = startSelectorPos
        }
        self.segemenedButton[index].setTitleColor(selectorColor, for: .normal)
    }
}
