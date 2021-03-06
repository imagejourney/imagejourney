//
//  ParseClient.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class ParseClient: NSObject {
    
    override init() {
        super.init()
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
            configuration.applicationId = "imagejourney"
            configuration.server = "https://imagejourney.herokuapp.com/parse"
        }))

    }
    
    class var sharedInstance: ParseClient {
        struct Static {
            static let instance = ParseClient()
        }
        return Static.instance
    }
    
    
    
    func getCurrentUser() -> PFUser? {
        return PFUser.current()
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func userSignIn(username:String, password:String, onSuccess: @escaping (_ user: PFUser) -> (), onError: @escaping (Error?) -> ()){
        PFUser.logInWithUsername(inBackground: username, password:password) {
            (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                onError(error)
            } else {
                onSuccess(user!)
            }
        }

    }
    
    func userSignUp(name:String, username:String, password:String, onSuccess: @escaping (_ user: PFUser) -> (), onError: @escaping (Error?) -> ()){
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.setValue(name, forKey: "name")
        newUser.signUpInBackground{(succeeded, error) -> Void in
            if let error = error {
                onError(error)
            } else {
                onSuccess(newUser)
            }
        }

    }
    
    func getCurrentUserMostRecentJournal(completion: @escaping (Journal?) -> ()){
        let journalsQuery = PFQuery(className: "Journal")
        journalsQuery.includeKey("author")
        journalsQuery.includeKey("entries")
        journalsQuery.whereKey("author", equalTo: PFUser.current()!)
        journalsQuery.order(byDescending: "createdAt")
        journalsQuery.getFirstObjectInBackground { (journalPFObject, error) in
            if error == nil && journalPFObject != nil {
                print("Got journal")
                let journal = Journal(obj: journalPFObject!)
                completion(journal)
            } else if error != nil {
                print("Could not get journal. Error: \(String(describing: error?.localizedDescription))");
            } else if journalPFObject == nil {
                print("no recent journal")
            }
        }
    }
    
    func getJournalsWithCompletion(currentUserOnly: Bool, completion: @escaping ([Journal]?) -> ()) {
        let journalsQuery = PFQuery(className: "Journal")
        journalsQuery.includeKey("author")
        journalsQuery.includeKey("entries")
        
        if currentUserOnly {
            journalsQuery.whereKey("author", equalTo: PFUser.current()!)
        }
        journalsQuery.order(byDescending: "createdAt")
        journalsQuery.findObjectsInBackground { (journalPFObjects: [PFObject]?, error: Error?) in
            if error == nil && journalPFObjects != nil && (journalPFObjects?.count)! > 0 {
                print("Got journals")
                let journals = Journal.journalsFromArray(pfObjectArray: journalPFObjects!)
                completion(journals)
            } else if error != nil {
                print("Could not get journals. Error: \(String(describing: error?.localizedDescription))");
            } else if journalPFObjects == nil || (journalPFObjects?.count)! <= 0 {
                print("no journals")
            }
        }
    }
    
    func searchByJournalTitle(searchText: String, completion: @escaping ([Journal]?) -> ()) {
        let query = PFQuery(className: "Journal")
        query.whereKey("title", matchesRegex: "(?i)(\(searchText))")
        
        query.findObjectsInBackground { (journals, error) -> Void in
            if error == nil && journals != nil && (journals?.count)! > 0 {
                print("Got journals")
                print(journals ?? "no journals")
                let journals = Journal.journalsFromArray(pfObjectArray: journals!)
                completion(journals)
            } else if error != nil {
                print("Could not get journals. Error: \(String(describing: error?.localizedDescription))");
            } else if journals == nil || (journals?.count)! <= 0 {
                print("no journals")
                completion([])
            }
        }
    }
    
    func searchByJournalLocation(lat: Double, long: Double, completion: @escaping ([Journal]?) -> ()) {
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        let query = PFQuery(className: "JournalEntry")
        query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 10.0);
        
        query.findObjectsInBackground { (entries, error) -> Void in
            if error == nil && entries != nil && (entries?.count)! > 0 {
                print("Got entries")
                print(entries ?? "no entries")
                let journalQuery = PFQuery(className: "Journal")
                // contained in checks if any of the "containedIn" elements exist in the array given by "key"
                journalQuery.whereKey("entries", containedIn: entries!)
                journalQuery.findObjectsInBackground { (journalPFObjects, error) -> Void in
                    if error == nil && journalPFObjects != nil && (journalPFObjects?.count)! > 0 {
                        print("Got journals")
                        print(journalPFObjects ?? "no journals")
                        let journals = Journal.journalsFromArray(pfObjectArray: journalPFObjects!)
                        completion(journals)
                    } else if error != nil {
                        print("Could not get entries. Error: \(String(describing: error?.localizedDescription))");
                    } else if entries == nil || (entries?.count)! <= 0 {
                        print("no entries")
                        completion([])
                    }
                }
            } else if error != nil {
                print("Could not get entries. Error: \(String(describing: error?.localizedDescription))");
            } else if entries == nil || (entries?.count)! <= 0 {
                print("no entries")
                completion([])
            }
        }
    }
    
    func saveJournal(title: String, desc:String, longtitude:CLLocationDegrees?, latitude: CLLocationDegrees?, entries: [JournalEntry], completion: @escaping (PFObject) -> ()) {
        let journalObj = PFObject(className:"Journal")
        journalObj["title"] = title
        journalObj["description"] = desc
        if latitude != nil {
            journalObj["latitude"] = latitude
        }
        if longtitude != nil {
            journalObj["longitude"] = longtitude
        }
        journalObj["author"] = PFUser.current()
        journalObj["entries"] = entries
        journalObj.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Journal saved!")
                completion(journalObj)
            } else {
                print("Could not save journal. Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func saveEntries(images: [UIImage]!, weather: String, date: Date, description: String?, title: String?, coordinate: CLLocationCoordinate2D, toJournal: Journal, completion: @escaping () -> ()) {
        // Save entry to Entry class
        let entryPFObject = PFObject(className: "JournalEntry")
        
        // Save UIImage as PFFile
        for i in images.indices {
            let image = images[i]
            let imageData = UIImageJPEGRepresentation(image, 0.8)!
            let imageFile = PFFile(data: imageData)
            entryPFObject["image\(i)"] = imageFile
        }
        
//        // Handle converting coordinates to PFGeoPoint
        let location = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)

        entryPFObject["weather"] = weather
        entryPFObject["date"] = date
        entryPFObject["description"] = description
        entryPFObject["title"] = title
        entryPFObject["location"] = location
        
        entryPFObject.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Entries saved! Now trying to associate with journal")
                let entryDict: [String: String] = ["__type":"Pointer",
                                                   "className":"JournalEntry",
                                                   "objectId":entryPFObject.objectId!]
                toJournal.pfObj?.add(entryDict, forKey: "entries")
                do {
                    try toJournal.pfObj?.save()
                } catch {
                    print(error)
                }
                completion()
            } else {
                print("Could not save entries. Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    

}
