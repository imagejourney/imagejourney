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
                    weatherIconView.image = UIImage(named: "cloudy-icon")
                case "Rain":
                    weatherIconView.image = UIImage(named: "rain-icon")
                case "Snow":
                    weatherIconView.image = UIImage(named: "snow-icon")
                default:
                    weatherIconView.image = UIImage(named: "sunny-icon")
            }
            JournalEntry.getLocationString(location: entry.location!, handler: {(locationString) -> Void in
                self.entryLocationLabel.text = locationString
            })
            entryImageView.image = entry.image
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
