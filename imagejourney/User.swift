//
//  User.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
let defaults = UserDefaults.standard
class User: NSObject {
    var name: String?
    var username: String?
    var email: String?
    var profileImageUrl: URL?
    
    init(obj: PFUser?) {
        self.name = obj?["name"] as? String
        self.username = obj?.username
        self.email = obj?.email
        if let profileImageUrl = obj?["profile_image_url"] as? String {
            self.profileImageUrl = URL(string: profileImageUrl)
        }
    }
    
    static var _currentUser: User?
    
    static func logout(){
        _currentUser = nil
        defaults.removeObject(forKey: Constants.USER_DEFAULTS_KEY)
    }

    static func setCurrentUser(user:PFUser){
        _currentUser = User(obj: user)
        var data:[String:String] = [:]
        data["name"] = user["name"] as? String
        data["username"] = user.username
        data["email"] = user.email
        data["profile_image_url"] = user["profile_image_url"] as? String
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        defaults.set(jsonData, forKey: Constants.USER_DEFAULTS_KEY)
    }

    static func getCurrentUser() -> User?{
        if _currentUser == nil {
            let userData = defaults.object(forKey: Constants.USER_DEFAULTS_KEY) as? Data
            if let userData = userData {
                let data = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String:String]
                let user = User(obj: nil)
                user.name = data["name"]
                user.email = data["email"]
                user.username = data["username"]
                if data["profile_image_url"] != nil {
                    user.profileImageUrl = URL(string: data["profile_image_url"]!)
                }
                
                _currentUser = user
            }
        }
        if _currentUser == nil {
            return nil
        } else {
            return _currentUser!
        }
    }
}
