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
        // we want to get preview images from entries?[0].imageUrls?[0]
        let previewImageOneUrl = URL(string: "http://www.sftravel.com/sites/sftraveldev.prod.acquia-sites.com/files/SanFrancisco_0.jpg")
        let previewImageTwoUrl = URL(string: "https://gravitypayments.com/wp-content/uploads/2017/01/coffee-shops.jpg")
        let previewImageThreeUrl = URL(string: "https://s-media-cache-ak0.pinimg.com/736x/e2/f4/1d/e2f41df8ac687d171da02c289379d5e3.jpg")

        previewImageUrls = []
        previewImageUrls?.append(previewImageOneUrl!)
        previewImageUrls?.append(previewImageTwoUrl!)
        previewImageUrls?.append(previewImageThreeUrl!)
    }
    
    func initTest() {
        title = "trip in sf"
        entries = []
        
        let previewImageOneUrl = URL(string: "http://www.sftravel.com/sites/sftraveldev.prod.acquia-sites.com/files/SanFrancisco_0.jpg")
        let previewImageTwoUrl = URL(string: "https://gravitypayments.com/wp-content/uploads/2017/01/coffee-shops.jpg")
        let previewImageThreeUrl = URL(string: "http://www.extranomical.com/sites/default/files/images/resource_page/resource_image/fishermans-wharf5-8403.jpg")
        
        previewImageUrls?.append(previewImageOneUrl!)
        previewImageUrls?.append(previewImageTwoUrl!)
        previewImageUrls?.append(previewImageThreeUrl!)
    }
}
