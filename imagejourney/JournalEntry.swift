//
//  JournalEntry.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/28/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
import MapKit

class JournalEntry: NSObject {
    var images: [UIImage]? = []
    var date: Date?
    var location: PFGeoPoint? // use Geo later
    var weather: String?
    var desc: String?
    var title: String?
    
    init(obj: PFObject) {
        do {
            try obj.fetchIfNeeded()
        } catch {
            print(error)
        }
        
        for index in 0...8 {
            if let imageFile = obj["image\(index)"] as? PFFile {
                var imageData: Data?
                do {
                    imageData = try imageFile.getData()
                    self.images?.append(UIImage(data:imageData!)!)
                } catch {
                    print(error)
                }
            }
        }

        self.date = obj["date"] as? Date
        self.location = obj["location"] as! PFGeoPoint
        self.title = obj["title"] as? String
        self.weather = obj["weather"] as? String
        self.desc = obj["description"] as? String
    }
    
    static func getLocationString(location: PFGeoPoint, handler: @escaping ((String) -> Void)) -> Void {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
        var locationString = "Unknown Location"
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                locationString = locationName
                if let state = placeMark.addressDictionary!["State"] as? String {
                    locationString = "\(locationName), \(state)"
                } else if let country = placeMark.addressDictionary!["Country"] as? String {
                    locationString = "\(locationName), \(country)"
                }
            }
            handler(locationString)
        })
    }
    
    class func journalEntriesFromArray(pfObjectArray: [PFObject]) -> [JournalEntry] {
        var entries = [JournalEntry]()
        
        for pfObject: PFObject in pfObjectArray {
            entries.append(JournalEntry(obj: pfObject))
        }
        
        return entries
    }
}
