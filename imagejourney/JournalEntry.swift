//
//  JournalEntry.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalEntry: NSObject {
    var imageUrls: [URL]?
    var date: Date?
    var location: String? // use Geo later
    var weather: String?
    var desc: String?
    
    init(dictionary: Dictionary<String, Any>) {
        imageUrls = dictionary["image_urls"] as? [URL]
        date = dictionary["date"] as? Date
        location = dictionary["location"] as? String
        weather = dictionary["weather"] as? String
        desc = dictionary["description"] as? String
    }
}
