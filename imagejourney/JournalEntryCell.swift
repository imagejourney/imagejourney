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
    @IBOutlet weak var entryWeatherLabel: UILabel!
    @IBOutlet weak var entryLocationLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDescriptionLabel: UILabel!
    
    var entry: JournalEntry! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss +zzzz"
            if let date = entry.date {
                entryTimeLabel.text = dateFormatter.string(from: date)
            }
            
            entryWeatherLabel.text = entry.weather
            entryLocationLabel.text = entry.location
            if let imageUrl = entry.imageUrls?[0] {
                entryImageView.setImageWith(imageUrl)
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
