//
//  JournalEntry.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

class JournalEntry: NSObject {
    var imageUrls: [URL]?
    var date: Date?
    var location: String? // use Geo later
    var weather: String?
    var desc: String?
    
    init(obj: PFObject) {
        self.imageUrls = obj["imageUrls"] as! [URL]
        self.date = obj["date"] as! Date
        self.location = obj["location"] as! String
        self.weather = obj["weather"] as! String
        self.desc = obj["description"] as! String
    }
    
    class func journalEntriesFromArray(pfObjectArray: [PFObject]) -> [JournalEntry] {
        var entries = [JournalEntry]()
        
        for pfObject: PFObject in pfObjectArray {
            entries.append(JournalEntry(obj: pfObject))
        }
        
        return entries
    }
}
