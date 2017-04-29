//
//  Journal.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class Journal: NSObject {
    var title: String?
    var author: User?
    var entries: [JournalEntry]?
    
    init(dictionary: Dictionary<String, Any>) {
        title = dictionary["title"] as? String
        let userDictionary = dictionary["author"] as? Dictionary<String, Any>
        if let userDictionary = userDictionary {
            author = User(dictionary: userDictionary)
        }
        entries = dictionary["entries"] as? [JournalEntry]
    }
}
