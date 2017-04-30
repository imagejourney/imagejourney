//
//  User.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    
    init(dictionary: Dictionary<String, Any>) {
        name = dictionary["name"] as? String
        
        //temp testing
        name = "sophia"
    }
}
