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
    var previewImageUrls: [URL]?
    
    init(dictionary: Dictionary<String, Any>) {
        title = dictionary["title"] as? String
        let userDictionary = dictionary["author"] as? Dictionary<String, Any>
        if let userDictionary = userDictionary {
            author = User(dictionary: userDictionary)
        }
        entries = dictionary["entries"] as? [JournalEntry]
        
        // temporary hardcoding for testing for now
        
        title = "Sophia's trip in SF"
        
        // we want to get preview images from entries?[0].imageUrls?[0]
        let previewImageOneUrl = URL(string: "https://cdn0.vox-cdn.com/uploads/chorus_asset/file/4858055/presidio_20cover.0.jpg")
        let previewImageTwoUrl = URL(string: "https://gravitypayments.com/wp-content/uploads/2017/01/coffee-shops.jpg")
        let previewImageThreeUrl = URL(string: "https://s-media-cache-ak0.pinimg.com/736x/e2/f4/1d/e2f41df8ac687d171da02c289379d5e3.jpg")

        previewImageUrls = []
        previewImageUrls?.append(previewImageOneUrl!)
        previewImageUrls?.append(previewImageTwoUrl!)
        previewImageUrls?.append(previewImageThreeUrl!)
    }
}
