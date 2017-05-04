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
    
    init(obj: PFUser?) {
        self.name = obj?["name"] as? String
        self.username = obj?.username
        self.email = obj?.email
    }
    
    static var _currentUser: User?
    
    static func setCurrentUser(user:PFUser){
        _currentUser = User(obj: user)
        var data:[String:String] = [:]
        data["name"] = user["name"] as? String
        data["username"] = user.username
        data["email"] = user.email
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        defaults.set(jsonData, forKey: Constants.USER_DEFAULTS_KEY)
    }

    static func getCurrentUser() -> User{
        if _currentUser == nil {
            let userData = defaults.object(forKey: Constants.USER_DEFAULTS_KEY) as? Data
            if let userData = userData {
                let data = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String:String]
                var user = User(obj: nil)
                user.name = data["name"]
                user.email = data["email"]
                user.username = data["username"]
                _currentUser = user
            }
        }
        return _currentUser!
    }
}
