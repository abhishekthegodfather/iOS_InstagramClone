//
//  CustomSearchController.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class CustomSearchController: UIView {

    var searchBar : UISearchBar
    
    init(customSearchController : UISearchBar) {
        self.searchBar = customSearchController
        super.init(frame: CGRect.zero)
        addSubview(customSearchController)
    }
    
    convenience override init(frame: CGRect) {
        self.init(customSearchController: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
    
}
