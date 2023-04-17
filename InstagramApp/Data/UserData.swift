//
//  UserData.swift
//  InstagramApp
//
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

struct User {
    var name: String
    var profileImage: UIImage
}

class UsersModel {
    
    var users: [User] = [User]()
    init() {
        let user1 = User(name: "John Carmack", profileImage: UIImage(named: "user1")!)
        users.append(user1)
        let user2 = User(name: "Bjarne Stroustrup", profileImage: UIImage(named: "user2")!)
        users.append(user2)
    }
}

class UserModel {
    static var firebaseDBReference : DatabaseReference {
        get{
            return Database.database().reference().child("users")
        }
    }
    
    var profileName : String = ""
    var bioProfile : String = ""
    
    init?(_ snapshot : DataSnapshot){
        guard let value = snapshot.value as? [String : Any] else { return }
        self.profileName = value["username"] as? String ?? ""
        self.bioProfile = value["bio"] as? String ?? ""
    }
}
