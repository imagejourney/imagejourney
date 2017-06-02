//
//  JournalEntryCell.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalEntryCell: UITableViewCell {

    @IBOutlet weak var entryTimeLabel: UILabel!
    @IBOutlet weak var entryLocationLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var topMapLine: UIView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var bottomMapLine: UIView!
    
    var isFirst: Bool! {
        didSet {
            topMapLine.isHidden = isFirst
        }
    }
    var isLast: Bool! {
        didSet {
            bottomMapLine.isHidden = isLast
        }
    }
    
    var entry: JournalEntry! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
            if let date = entry.date {
                entryTimeLabel.text = dateFormatter.string(from: date)
            }
            
            let weatherTypeString: String = entry.weather!
            switch weatherTypeString {
                case "Cloudy":
                    weatherIconView.image = UIImage(named: "cloud")
                case "Rainy":
                    weatherIconView.image = UIImage(named: "rain")
                case "Snowy":
                    weatherIconView.image = UIImage(named: "snow")
                case "Flashy":
                    weatherIconView.image = UIImage(named: "flash")
                default:
                    weatherIconView.image = UIImage(named: "sun")
            }
            Helper.getLocationString(location: entry.location!, handler: {(locationString) -> Void in
                self.entryLocationLabel.text = locationString
            })
            if (entry.images?.isEmpty)! {
               entryImageView.image = #imageLiteral(resourceName: "preview_image_placeholder")
            } else{
               entryImageView.image = entry.images?[0]
            }
            entryDescriptionLabel.text = entry.desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
