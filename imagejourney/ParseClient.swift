//
//  ParseClient.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

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
        newUser.signUpInBackground{(succeeded: Bool, error: Error!) -> Void in
            if let error = error {
                onError(error)
            } else {
                onSuccess(newUser)
            }
        }

    }
    func getJournalsWithCompletion(completion: @escaping ([Journal]?) -> ()) {
        let journalQuery = PFQuery(className: "Journal")
        journalQuery.includeKey("author")
        
        journalQuery.findObjectsInBackground { (journalPFObjects: [PFObject]?, error: Error?) in
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
    
    func saveJournal(title: String, entries: [JournalEntry], previewImageUrls: [URL]) {
        let journalObj = PFObject(className:"Journal")
        journalObj["title"] = title
        journalObj["author"] = PFUser.current()
        journalObj["entries"] = entries
        journalObj["previewImageUrls"] = previewImageUrls
        journalObj.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Journal saved!")
            } else {
                print("Could not save journal. Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }


}
