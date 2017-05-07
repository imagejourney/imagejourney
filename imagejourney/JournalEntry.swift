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
    var imageUrls: [URL]? = []
    var date: Date?
    var location: PFGeoPoint? // use Geo later
    var weather: String?
    var desc: String?
    
    init(obj: PFObject) {
        do {
            try obj.fetchIfNeeded()
        } catch {
            print(error)
        }
        let imageUrlArray = obj["imageUrls"] as! [Any]
        for imageUrlAny in imageUrlArray {
            if let imageUrl = URL(string: (imageUrlAny as? String)!) {
                imageUrls?.append(imageUrl)
            }
        }
        self.date = obj["date"] as! Date
        self.location = obj["location"] as! PFGeoPoint
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
