//
//  JournalCell.swift
//  imagejourney
//
//  Created by Sophia on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import AFNetworking
import UIKit
import Parse

class JournalCell: UITableViewCell {

    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet var authorProfileImg: UIImageView!
    @IBOutlet weak var imageCollageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildCellWithJournal(journal: Journal) {
        // If authorProfileImg is nil, it's in ProfileView
        if authorProfileImg != nil {
            authorProfileImg.layer.cornerRadius = authorProfileImg.frame.size.width/2
            authorProfileImg.clipsToBounds = true
            if journal.author?.profileImageUrl != nil {
                authorProfileImg.setImageWith((journal.author?.profileImageUrl)!)
            } else {
                authorProfileImg.image = UIImage(named: "avatar-\(arc4random_uniform(6) + 1)")
            }
        }
        if authorName != nil {
            authorName.text = "\(journal.author?.name ?? "anonymous")"
        }
        self.journalTitleLabel.text = journal.title
        if let latitude = journal.latitude as CLLocationDegrees!, let longitude = journal.longitude as CLLocationDegrees! {
            let geoPoint = PFGeoPoint.init(latitude: latitude, longitude: longitude)
            Helper.getLocationString(location: geoPoint, handler: {(locationString) -> Void in
                let splits:[String] = locationString.components(separatedBy: ",")
                self.tripTitleLabel.text = "\(splits.last!.trimmingCharacters(in: NSCharacterSet.whitespaces))"
            })
        }

        
        // Clear images from previous view
        for subview in self.imageCollageView.subviews {
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }

        var counter = 0
        var currColumnHeights = [0, 0, 0]
        while counter < 6 {
            if (journal.previewImages != nil && (journal.previewImages?.count)! > counter) {
                let uiImage = UIImageView(image: journal.previewImages?[counter])
                if (uiImage.frame.height >= uiImage.frame.width) {
                    let scaleFactor = uiImage.frame.width / 110
                    var newHeight = Int(uiImage.frame.height / scaleFactor)
                    newHeight = (newHeight + currColumnHeights[counter % 3]) < Int(imageCollageView.frame.height) ? newHeight : Int(imageCollageView.frame.height) - currColumnHeights[counter % 3]
                    uiImage.frame = CGRect(x: (counter % 3) * 115, y: currColumnHeights[counter % 3], width: 110, height: newHeight)
                    currColumnHeights[counter % 3] = newHeight + 5
                } else {
                    uiImage.frame = CGRect(x: (counter % 3) * 115, y: currColumnHeights[counter % 3], width: 110, height: 110)
                    currColumnHeights[counter % 3] = 115
                }
                uiImage.contentMode = UIViewContentMode.scaleAspectFill
                uiImage.masksToBounds = true
                uiImage.tag = 999
                imageCollageView.addSubview(uiImage)
            } else {
                let newHeight = currColumnHeights[counter % 3] == 0 ? 110 : imageCollageView.frame.height - CGFloat(currColumnHeights[counter % 3]) - 5.0;
                let view = UIView(frame: CGRect(x: (counter % 3) * 115, y: currColumnHeights[counter % 3], width: 110, height: Int(newHeight)))
                if (currColumnHeights[counter % 3] == 0) {
                    currColumnHeights[counter % 3] = 115
                }
                view.backgroundColor = Constants.LIGHT_GRAY
                view.tag = 999
                view.masksToBounds = true
                imageCollageView.addSubview(view)
            }
            imageCollageView.cornerRadius = 5
            imageCollageView.masksToBounds = true
            counter += 1
        }
    }
}
