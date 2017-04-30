//
//  JournalCell.swift
//  imagejourney
//
//  Created by Sophia on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import AFNetworking
import UIKit

class JournalCell: UITableViewCell {

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var previewImageOne: UIImageView!
    @IBOutlet weak var previewImageTwo: UIImageView!
    @IBOutlet weak var previewImageThree: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildCellWithJournal(journal: Journal) {
        tripTitleLabel.text = journal.title
        authorName.text = journal.author?.name
        previewImageOne.setImageWith((journal.previewImageUrls?[0])!)
        previewImageTwo.setImageWith((journal.previewImageUrls?[1])!)
        previewImageThree.setImageWith((journal.previewImageUrls?[2])!)
    }

}
