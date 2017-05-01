//
//  User.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

class User: NSObject {
    var name: String?
    var username: String?
    
    init(obj: PFObject) {
        self.name = obj["name"] as! String
        self.username = obj["username"] as! String
    }
    
    class func userFromPFUser(pfUser: PFUser) -> User {
        return User(obj: pfUser)
    }
}
