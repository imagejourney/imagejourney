//
//  Journal.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
import GoogleMaps

class Journal: NSObject {
    var title: String?
    var author: User?
    var entries: [JournalEntry]?
    var previewImages: [UIImage]? = []
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var pfObj: PFObject?
    let PREVIEW_IMAGES_LIMIT = 6
    init(obj: PFObject) {
        do {
            try obj.fetchIfNeeded()
        } catch {
            print(error)
        }
        self.pfObj = obj
        self.title = obj["title"] as! String
        self.latitude = obj["latitude"] as? CLLocationDegrees
        self.longitude = obj["longitude"] as? CLLocationDegrees
        let pfUser = obj["author"] as! PFUser
        self.author = User(obj: pfUser)
        let entryObjArray = obj["entries"] as! [PFObject]
        self.entries = JournalEntry.journalEntriesFromArray(pfObjectArray: entryObjArray)

        for entry in self.entries! {
            if (previewImages?.count)! >= PREVIEW_IMAGES_LIMIT {
                break
            }
            let images = entry.images
            if !(images?.isEmpty)!{
                for image in images!{
                    previewImages?.append(image)
                }
            }
        }
    }
    
    class func journalsFromArray(pfObjectArray: [PFObject]) -> [Journal] {
        var journals = [Journal]()
        
        for pfObject:PFObject in pfObjectArray {
            journals.append(Journal(obj: pfObject))
        }
        
        return journals
    }
    
    func reloadJournalData() {
        do {
            try pfObj?.fetchIfNeeded()
        } catch {
            print(error)
        }
        let entryObjArray = pfObj?["entries"] as! [PFObject]
        self.entries = JournalEntry.journalEntriesFromArray(pfObjectArray: entryObjArray)
    }
}
