//
//  NewPageConstants.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation

class NewPageConstants {
    @frozen enum newPageToShow : Int {
        case library, camera
        
        var identifier : String {
            switch self {
            case .library:
                return Constants.LibraryVCID
            case .camera:
                return Constants.profileVCID
            }
        }
        
        static func pageToBeingShown() -> [newPageToShow] {
            return [.library, .camera]
        }
    }
}
